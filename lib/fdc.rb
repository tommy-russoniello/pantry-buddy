module Fdc
  API_HOST = 'api.nal.usda.gov'.freeze
  API_KEY = ENV.fetch('FDC_API_KEY')
  SEARCH_PATH = '/fdc/v1/foods/search'.freeze

  class << self
    def get_data_from_upc(upc)
      data = send_request(
        host: API_HOST,
        method: :get,
        name: 'UPC lookup',
        path: SEARCH_PATH,
        query: { query: upc }
      )&.dig('foods')&.find { |food| food['gtinUpc'] == upc }

      return unless data

      nutrients_data = data['foodNutrients'].map do |nutrient_data|
        nutrient = nutrient_mappings[nutrient_data['nutrientId'].to_s]
        next unless nutrient

        value =
          case nutrient_data['unitName']
          when 'G'
            nutrient_data['value']
          when 'MG'
            nutrient_data['value'] / 1_000
          when 'UG'
            nutrient_data['value'] / 1_000_000
          when 'IU'
            international_units_to_grams(nutrient_data['value'], nutrient)
          when 'KCAL'
            nutrient_data['value']
          end

        value /= 100 if value
        [nutrient, value]
      end.compact.sort_by(&:first).to_h

      {
        fdc_id: data['fdcId'],
        name: data['description'],
        nutrients: nutrients_data
      }
    end

    private

    def international_units_to_grams(value, type)
      case type
      # One IU of Vitamin A is equivalent to 0.3 micrograms of retinol
      when :vitamin_a
        value * 0.0000003

      # One IU of Vitamin D is equivalent to 0.025 micrograms of cholecalciferol or ergocalciferol
      when :vitamin_d
        value * 0.000000025
      end
    end

    def nutrient_mappings
      @nutrient_mappings ||= {
        '1235' => :added_sugar,
        '1087' => :calcium,
        '1008' => :calories,
        '1005' => :carbs,
        '1253' => :cholesterol,
        '1004' => :fat,
        '1079' => :fiber,
        '1089' => :iron,
        '1090' => :magnesium,
        '1292' => :monounsaturated_fat,
        '1167' => :niacin,
        '1091' => :phosphorus,
        '1293' => :polyunsaturated_fat,
        '1092' => :potassium,
        '1003' => :protein,
        '1166' => :riboflavin,
        '1258' => :saturated_fat,
        '1093' => :sodium,
        '2000' => :sugar,
        '1165' => :thiamin,
        '1257' => :trans_fat,
        '1104' => :vitamin_a,
        '1175' => :vitamin_b6,
        '1178' => :vitamin_b12,
        '1162' => :vitamin_c,
        '1110' => :vitamin_d,
        '1109' => :vitamin_e,
        '1185' => :vitamin_k,
        '1095' => :zinc
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
            query: query.merge(api_key: API_KEY).to_query
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
      Rails.logger.error("FDC#{' ' if name.present?}#{name} error: #{message}")

      nil
    rescue JSON::ParserError
      nil
    end
  end
end
