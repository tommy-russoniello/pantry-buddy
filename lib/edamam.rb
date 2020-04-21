module Edamam
  API_HOST = 'api.edamam.com'.freeze
  APP_ID = ENV.fetch('EDAMAM_APP_ID')
  APP_KEY = ENV.fetch('EDAMAM_APP_KEY')
  MEASUREMENT_URI_PREFIX = 'http://www.edamam.com/ontologies/edamam.owl#Measure_'.freeze
  NUTRITION_DATA_PATH = '/api/food-database/nutrients'.freeze
  UPC_LOOKUP_PATH = '/api/food-database/parser'.freeze

  class << self
    def get_grams_per_measurement_unit(food_id:, measurement:)
      data = send_request(
        body: {
          ingredients: [
            {
              quantity: 1,
              measureURI: measurement_uri(measurement),
              foodId: food_id
            }
          ]
        }.to_json,
        headers: { 'Content-Type': 'application/json' },
        host: API_HOST,
        method: :post,
        name: 'measurement data',
        path: NUTRITION_DATA_PATH
      )
      get_weight_from_nutrition_data_response(data)
    end

    def get_nutrition_data_from_upc(upc)
      upc_lookup_data = send_request(
        host: API_HOST,
        method: :get,
        name: 'UPC lookup',
        path: UPC_LOOKUP_PATH,
        query: { upc: upc }
      )&.dig('hints', 0)

      return unless upc_lookup_data

      food_data = upc_lookup_data['food']
      return unless food_data

      food_id = food_data['foodId']
      name = food_data['label']

      measurement_data = upc_lookup_data['measures']
      measurement_units = measurement_data.map do |measure|
        [measure['label'], measure['uri'].match(/^#{MEASUREMENT_URI_PREFIX}([a-z]+)$/)[1]]
      end.compact.to_h

      volumetric = measurement_units.key?('Tablespoon')
      request_data = {
        body: {
          ingredients: [
            {
              quantity: 1,
              measureURI: measurement_uri(volumetric ? 'tablespoon' : 'gram'),
              foodId: food_id
            }
          ]
        }.to_json,
        headers: { 'Content-Type': 'application/json' },
        host: API_HOST,
        method: :post,
        name: 'nutrition data',
        path: NUTRITION_DATA_PATH
      }
      response = send_request(request_data)

      grams_per_tablespoon = get_weight_from_nutrition_data_response(response) if volumetric

      nutrients = response['totalNutrients']
      return unless nutrients

      divisor = grams_per_tablespoon || 1
      calories = cast_decimal(nutrients.dig('ENERC_KCAL', 'quantity'))
      calories /= divisor if calories
      nutrients_data = nutrient_mappings.map do |nutrient, code|
        nutrient_data = nutrients[code]
        value =
          if nutrient_data
            case nutrient_data['unit']
            when 'g'
              cast_decimal(nutrient_data['quantity']) / divisor
            when 'mg'
              cast_decimal(nutrient_data['quantity']) / divisor / 1_000
            when 'µg'
              cast_decimal(nutrient_data['quantity']) / divisor / 1_000_000
            end
          end

        [nutrient, value]
      end.to_h.merge(calories: calories)

      {
        food_id: food_id,
        grams_per_tablespoon: grams_per_tablespoon,
        health_labels: response['healthLabels'],
        measurement_units: measurement_units,
        name: name,
        nutrients: nutrients_data
      }
    end

    private

    def cast_decimal(value)
      Kernel.Float(value).to_d
    rescue ArgumentError, TypeError
      nil
    end

    def get_weight_from_nutrition_data_response(data)
      data = data&.dig('ingredients', 0, 'parsed', 0)
      cast_decimal(data['weight']) unless data['status'] == 'MISSING_QUANTITY'
    end

    def measurement_uri(measurement_name)
      "#{MEASUREMENT_URI_PREFIX}#{measurement_name.parameterize.underscore}"
    end

    def nutrient_mappings
      {
        added_sugar: 'SUGAR.added',
        calcium: 'CA',
        carbs: 'CHOCDF',
        cholesterol: 'CHOLE',
        fat: 'FAT',
        fiber: 'FIBTG',
        iron: 'FE',
        magnesium: 'MG',
        monounsaturated_fat: 'FAMS',
        niacin: 'NIA',
        phosphorus: 'P',
        polyunsaturated_fat: 'FAPU',
        potassium: 'K',
        protein: 'PROCNT',
        riboflavin: 'RIBF',
        saturated_fat: 'FASAT',
        sodium: 'NA',
        sugar: 'SUGAR',
        thiamin: 'THIA',
        trans_fat: 'FATRN',
        vitamin_a: 'VITA_RAE',
        vitamin_b6: 'VITB6A',
        vitamin_b12: 'VITB12',
        vitamin_c: 'VITC',
        vitamin_d: 'VITD',
        vitamin_e: 'TOCPHA',
        vitamin_k: 'VITK1',
        zinc: 'ZN'
      }
    end

    def send_request(body: nil, headers: {}, host:, method:, name: nil, path: '', query: {})
      ActiveSupport::JSON.decode(
        RestClient::Request.execute(
          headers: headers,
          method: method,
          payload: body,
          url: URI::HTTPS.build(
            host: host,
            path: path,
            query: query.merge(app_id: APP_ID, app_key: APP_KEY).to_query
          ).to_s
        )
      )
    rescue RestClient::ExceptionWithResponse => error
      error_response =
        begin
          ActiveSupport::JSON.decode(error.response || '')['message']
        rescue JSON::ParserError
          error.response
        end

      message = error_response || error.message
      Rails.logger.error("Edamam#{' ' if name.present?}#{name} error: #{message}")

      nil
    rescue JSON::ParserError
      nil
    end
  end
end
