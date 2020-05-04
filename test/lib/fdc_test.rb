class FdcTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @upc = 'upc'
    @url = "https://#{Fdc::API_HOST}#{Fdc::SEARCH_PATH}?api_key=#{Fdc::API_KEY}&query=#{@upc}"
  end

  tests_for('get data from upc') do
    test('get data from upc - success') do
      fdc_id = 'fdc id'
      name = 'name'

      nutrient_mappings = {
        calories: '1',
        carbs: '2',
        fat: '3',
        protein: '4',
        sugar: '5',
        vitamin_a: '6'
      }
      Fdc.stubs(:nutrient_mappings).returns(nutrient_mappings.invert)

      nutrients = {
        calories: 5.1,
        carbs: 0.55,
        fat: 0.3,
        protein: 0.15,
        sugar: nil,
        vitamin_a: 0.000001
      }

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @url
        )
        .returns(
          {
            'foods' => [
              { 'gtinUpc' => 'different upc' },
              {
                'description' => name,
                'fdcId' => fdc_id,
                'foodNutrients' => [
                  {
                    'nutrientId' => nutrient_mappings[:calories],
                    'unitName' => 'KCAL',
                    'value' => nutrients[:calories] * 100
                  },
                  {
                    'nutrientId' => nutrient_mappings[:carbs],
                    'unitName' => 'G',
                    'value' => nutrients[:carbs] * 100
                  },
                  {
                    'nutrientId' => nutrient_mappings[:fat],
                    'unitName' => 'MG',
                    'value' => nutrients[:fat] * 100_000
                  },
                  {
                    'nutrientId' => nutrient_mappings[:protein],
                    'unitName' => 'UG',
                    'value' => nutrients[:protein] * 100_000_000
                  },
                  {
                    'nutrientId' => nutrient_mappings[:vitamin_a],
                    'unitName' => 'IU',
                    'value' => (nutrients[:vitamin_a] / 0.0000003) * 100
                  },
                  {
                    'nutrientId' => nutrient_mappings[:sugar],
                    'unitName' => 'some unit we don\'t support',
                    'value' => 1
                  },
                  {
                    'nutrientId' => 'something we don\'t care about',
                    'unitName' => 'G',
                    'value' => 1
                  }
                ],
                'gtinUpc' => @upc
              }
            ]
          }.to_json
        )

      assert_equal(
        {
          fdc_id: fdc_id,
          name: name,
          nutrients: nutrients
        },
        Fdc.get_data_from_upc(@upc),
        'data'
      )
    end

    test('get data from upc - no matching food') do
      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @url
        )
        .returns(
          {
            'foods' => [{ 'gtinUpc' => 'different upc' }]
          }.to_json
        )

      assert_nil(Fdc.get_data_from_upc(@upc), 'no data')
    end

    test('get data from upc - request error') do
      error_message = 'error message'
      error = RestClient::ExceptionWithResponse.new(
        ActiveSupport::JSON.encode(message: error_message, success: false)
      )

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @url
        )
        .raises(error)
      Rails.logger.expects(:error).with("FDC UPC lookup error: #{error_message}")

      assert_nil(Fdc.get_data_from_upc(@upc), 'no data')
    end

    test('get data from upc - response parse error') do
      mock_response = mock
      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @url
        )
        .returns(mock_response)
      ActiveSupport::JSON.expects(:decode).with(mock_response).raises(JSON::ParserError)

      assert_nil(Fdc.get_data_from_upc(@upc), 'no data')
    end
  end
end
