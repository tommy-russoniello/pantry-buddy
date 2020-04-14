module Edamam
  APP_ID = ENV.fetch('EDAMAM_APP_ID')
  APP_KEY = ENV.fetch('EDAMAM_APP_KEY')
  MEASUREMENT_URI = 'http://www.edamam.com/ontologies/edamam.owl#Measure_gram'.freeze
  NUTRITION_DATA_URL = 'https://api.edamam.com/api/food-database/nutrients'.freeze
  UPC_LOOKUP_URL = 'https://api.edamam.com/api/food-database/parser'.freeze

  class << self
    def get_nutrition_data_from_upc(upc)
      food_id = send_request(method: :get, name: 'UPC lookup', url: "#{UPC_LOOKUP_URL}?upc=#{upc}")
        &.dig('hints')
        &.first
        &.dig('food', 'foodId')

      return unless food_id

      nutrients = send_request(
        body: {
          ingredients: [{ quantity: 1, measureURI: MEASUREMENT_URI, foodId: food_id }]
        }.to_json,
        headers: { 'Content-Type': 'application/json' },
        method: :post,
        name: 'nutrition data',
        url: NUTRITION_DATA_URL
      )&.dig('totalNutrients')

      return unless nutrients

      data = nutrient_mappings.map do |nutrient, code|
        nutrient_data = nutrients[code]
        if nutrient_data
          value =
            case nutrient_data['unit']
            when 'g'
              cast_decimal(nutrient_data['quantity'])
            when 'mg'
              cast_decimal(nutrient_data['quantity']) * 1_000
            when 'µg'
              cast_decimal(nutrient_data['quantity']) * 1_000_000
            else
              nil
            end
        end

        [nutrient, value]
      end.to_h

      data.merge(calories: cast_decimal(nutrients.dig('ENERC_KCAL', 'quantity')))
    end

    private

    def cast_decimal(value)
      Kernel.Float(value).to_d
    rescue ArgumentError, TypeError
      nil
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
