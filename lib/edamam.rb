module Edamam
  APP_ID = ENV.fetch('EDAMAM_APP_ID')
  APP_KEY = ENV.fetch('EDAMAM_APP_KEY')
  MEASUREMENT_URI_PREFIX = 'http://www.edamam.com/ontologies/edamam.owl#Measure_'.freeze
  NUTRITION_DATA_URL = 'https://api.edamam.com/api/food-database/nutrients'.freeze
  UPC_LOOKUP_URL = 'https://api.edamam.com/api/food-database/parser'.freeze

  class << self
    def get_grams_per_measurement_unit(food_id:, measurement_name:)
      data = send_request(
        body: {
          ingredients: [
            {
              quantity: 1,
              measureURI: "#{MEASUREMENT_URI_PREFIX}#{measurement_name.parameterize.underscore}",
              foodId: food_id
            }
          ]
        }.to_json,
        headers: { 'Content-Type': 'application/json' },
        method: :post,
        name: 'measurement data',
        url: NUTRITION_DATA_URL
      )
      get_weight_from_nutrition_data_response(data)
    end

    def get_nutrition_data_from_upc(upc)
      upc_lookup_data = send_request(method: :get, name: 'UPC lookup', url: "#{UPC_LOOKUP_URL}?upc=#{upc}")
        &.dig('hints')
        &.first

      return unless upc_lookup_data&.is_a?(Hash)

      food_data = upc_lookup_data['food']
      return unless food_data&.is_a?(Hash)

      food_id = food_data['foodId']
      name = food_data['label']
      return unless food_id && name

      measurement_data = upc_lookup_data['measures']
      measurement_units =
        if measurement_data&.is_a?(Array)
          measurement_data.map { |measure| measure['label'] if measure&.is_a?(Hash) }.compact
        else
          []
        end

      body = {
        ingredients: [
          {
            quantity: 1,
            measureURI: "#{MEASUREMENT_URI_PREFIX}tablespoon",
            foodId: food_id
          }
        ]
      }
      request_data = {
        body: body.to_json,
        headers: { 'Content-Type': 'application/json' },
        method: :post,
        name: 'nutrition data',
        url: NUTRITION_DATA_URL
      }
      response = send_request(request_data)

      grams_per_tablespoon = get_weight_from_nutrition_data_response(response)
      unless grams_per_tablespoon
        body[:ingredients].first[:measureURI] = "#{MEASUREMENT_URI_PREFIX}gram"
        request_data[:body] = body.to_json
        response = send_request(request_data)
      end

      nutrients = response['totalNutrients']
      return unless nutrients

      divisor = grams_per_tablespoon || 1
      nutrients_data = nutrient_mappings.map do |nutrient, code|
        nutrient_data = nutrients[code]
        value =
          if nutrient_data
            case nutrient_data['unit']
            when 'g'
              cast_decimal(nutrient_data['quantity']) / divisor
            when 'mg'
              cast_decimal(nutrient_data['quantity']) / divisor * 1_000
            when 'µg'
              cast_decimal(nutrient_data['quantity']) / divisor * 1_000_000
            else
              nil
            end
          end

        [nutrient, value]
      end.to_h.merge(calories: cast_decimal(nutrients.dig('ENERC_KCAL', 'quantity')))

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
      return unless data&.is_a?(Hash)

      data = data['ingredients']
      return unless data&.is_a?(Array)

      data = data.first
      return unless data&.is_a?(Hash)

      data = data['parsed']
      return unless data&.is_a?(Array)

      data = data.first
      return unless data&.is_a?(Hash)

      data['weight'] unless data['status'] == 'MISSING_QUANTITY'
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

    def send_request(body: nil, headers: {}, method:, name: nil, url:)
      ActiveSupport::JSON.decode(
        RestClient::Request.execute(
          headers: headers,
          method: method,
          payload: body,
          url: "#{url}#{url.include?('?') ? '&' : '?'}app_id=#{APP_ID}&app_key=#{APP_KEY}"
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
