class EdamamTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @upc = 'upc'
    @upc_lookup_url = "https://#{Edamam::API_HOST}#{Edamam::UPC_LOOKUP_PATH}?" \
      "app_id=#{Edamam::APP_ID}&app_key=#{Edamam::APP_KEY}&upc=#{@upc}"
    @nutrition_data_url = "https://#{Edamam::API_HOST}#{Edamam::NUTRITION_DATA_PATH}?" \
      "app_id=#{Edamam::APP_ID}&app_key=#{Edamam::APP_KEY}"
  end

  tests_for('get data from upc') do
    test('get data from upc - success - not volumetric') do
      edamam_id = 'edamam id'
      health_labels = %w[dairy_free vegan random]
      measurement_units = { 'name' => 'uri_fragment_suffix' }
      name = 'name'
      nutrients = {
        calories: 5.1,
        carbs: 0.55,
        fat: 0.3,
        protein: 0.15,
        sugar: nil
      }

      nutrient_mappings = {
        calories: '1',
        carbs: '2',
        fat: '3',
        protein: '4',
        sugar: '5',
        vitamin_a: '6'
      }
      Edamam.stubs(:nutrient_mappings).returns(nutrient_mappings)

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @upc_lookup_url
        )
        .returns(
          {
            'hints' => [
              {
                'food' => { 'foodId' => edamam_id, 'label' => name },
                'measures' => measurement_units.map do |unit_name, uri_fragment_suffix|
                  {
                    'label' => unit_name,
                    'uri' => "#{Edamam::MEASUREMENT_URI_PREFIX}#{uri_fragment_suffix}"
                  }
                end
              }
            ]
          }.to_json
        )

      RestClient::Request
        .expects(:execute)
        .with(
          headers: { 'Content-Type': 'application/json' },
          method: :post,
          payload: {
            ingredients: [
              {
                quantity: 1,
                measureURI: "#{Edamam::MEASUREMENT_URI_PREFIX}gram",
                foodId: edamam_id
              }
            ]
          }.to_json,
          url: @nutrition_data_url
        )
        .returns(
          {
            'healthLabels' => health_labels,
            'totalNutrients' => {
              nutrient_mappings[:calories] => {
                'quantity' => nutrients[:calories],
                'unit' => 'doesn\'t matter'
              },
              nutrient_mappings[:carbs] => { 'quantity' => nutrients[:carbs], 'unit' => 'g' },
              nutrient_mappings[:fat] => { 'quantity' => nutrients[:fat] * 1_000, 'unit' => 'mg' },
              nutrient_mappings[:protein] => {
                'quantity' => nutrients[:protein] * 1_000_000,
                'unit' => 'µg'
              },
              nutrient_mappings[:sugar] => {
                'quantity' => nutrients[:sugar],
                'unit' => 'unit we don\'t support'
              },
              'something we don\'t care about' => { 'quantity' => '1.0', 'unit' => 'g' }
            }
          }.to_json
        )

      assert_equal(
        {
          edamam_id: edamam_id,
          grams_per_tablespoon: nil,
          health_labels: health_labels,
          measurement_units: measurement_units,
          name: name,
          nutrients: nutrient_mappings.map { |nutrient, _| [nutrient, nutrients[nutrient]] }.to_h
        },
        Edamam.get_data_from_upc(@upc, nutrients: true),
        'data'
      )
    end

    test('get data from upc - success - volumetric') do
      edamam_id = 'edamam id'
      grams_per_tablespoon = 2.5
      health_labels = %w[dairy_free vegan random]
      measurement_units = { 'Tablespoon' => 'tablespoon', 'name' => 'uri_fragment_suffix' }
      name = 'name'
      nutrients = {
        calories: 5.1,
        carbs: 0.55,
        fat: 0.3,
        protein: 0.15,
        sugar: nil
      }

      nutrient_mappings = {
        calories: '1',
        carbs: '2',
        fat: '3',
        protein: '4',
        sugar: '5',
        vitamin_a: '6'
      }
      Edamam.stubs(:nutrient_mappings).returns(nutrient_mappings)

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @upc_lookup_url
        )
        .returns(
          {
            'hints' => [
              {
                'food' => { 'foodId' => edamam_id, 'label' => name },
                'measures' => measurement_units.map do |unit_name, uri_fragment_suffix|
                  {
                    'label' => unit_name,
                    'uri' => "#{Edamam::MEASUREMENT_URI_PREFIX}#{uri_fragment_suffix}"
                  }
                end
              }
            ]
          }.to_json
        )

      RestClient::Request
        .expects(:execute)
        .with(
          headers: { 'Content-Type': 'application/json' },
          method: :post,
          payload: {
            ingredients: [
              {
                quantity: 1,
                measureURI: "#{Edamam::MEASUREMENT_URI_PREFIX}tablespoon",
                foodId: edamam_id
              }
            ]
          }.to_json,
          url: @nutrition_data_url
        )
        .returns(
          {
            'healthLabels' => health_labels,
            'ingredients' => [
              {
                'parsed' => [{ 'weight' => grams_per_tablespoon.to_s, 'status' => 'ok' }]
              }
            ],
            'totalNutrients' => {
              nutrient_mappings[:calories] => {
                'quantity' => nutrients[:calories] * grams_per_tablespoon,
                'unit' => 'doesn\'t matter'
              },
              nutrient_mappings[:carbs] => {
                'quantity' => nutrients[:carbs] * grams_per_tablespoon,
                'unit' => 'g'
              },
              nutrient_mappings[:fat] => {
                'quantity' => nutrients[:fat] * grams_per_tablespoon * 1_000,
                'unit' => 'mg'
              },
              nutrient_mappings[:protein] => {
                'quantity' => nutrients[:protein] * grams_per_tablespoon * 1_000_000,
                'unit' => 'µg'
              },
              nutrient_mappings[:sugar] => {
                'quantity' => nutrients[:sugar],
                'unit' => 'unit we don\'t support'
              },
              'something we don\'t care about' => { 'quantity' => '1.0', 'unit' => 'g' }
            }
          }.to_json
        )

      assert_equal(
        {
          edamam_id: edamam_id,
          grams_per_tablespoon: grams_per_tablespoon,
          health_labels: health_labels,
          measurement_units: measurement_units,
          name: name,
          nutrients: nutrient_mappings.map { |nutrient, _| [nutrient, nutrients[nutrient]] }.to_h
        },
        Edamam.get_data_from_upc(@upc, nutrients: true),
        'data'
      )
    end

    test('get data from upc - success - no nutrients') do
      edamam_id = 'edamam id'
      health_labels = %w[dairy_free vegan random]
      measurement_units = { 'name' => 'uri_fragment_suffix' }
      name = 'name'

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @upc_lookup_url
        )
        .returns(
          {
            'hints' => [
              {
                'food' => { 'foodId' => edamam_id, 'label' => name },
                'measures' => measurement_units.map do |unit_name, uri_fragment_suffix|
                  {
                    'label' => unit_name,
                    'uri' => "#{Edamam::MEASUREMENT_URI_PREFIX}#{uri_fragment_suffix}"
                  }
                end
              }
            ]
          }.to_json
        )

      RestClient::Request
        .expects(:execute)
        .with(
          headers: { 'Content-Type': 'application/json' },
          method: :post,
          payload: {
            ingredients: [
              {
                quantity: 1,
                measureURI: "#{Edamam::MEASUREMENT_URI_PREFIX}gram",
                foodId: edamam_id
              }
            ]
          }.to_json,
          url: @nutrition_data_url
        )
        .returns({ 'healthLabels' => health_labels }.to_json)

      assert_equal(
        {
          edamam_id: edamam_id,
          grams_per_tablespoon: nil,
          health_labels: health_labels,
          measurement_units: measurement_units,
          name: name
        },
        Edamam.get_data_from_upc(@upc),
        'data'
      )
    end

    test('get data from upc - upc lookup request error') do
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
          url: @upc_lookup_url
        )
        .raises(error)
      Rails.logger.expects(:error).with("Edamam UPC lookup error: #{error_message}")

      assert_nil(Edamam.get_data_from_upc(@upc), 'no data')
    end

    test('get data from upc - nutrition data request error') do
      edamam_id = 'edamam id'

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @upc_lookup_url
        )
        .returns(
          {
            'hints' => [
              {
                'food' => { 'foodId' => edamam_id, 'label' => 'name' },
                'measures' => []
              }
            ]
          }.to_json
        )

      error_message = 'error message'
      error = RestClient::ExceptionWithResponse.new(
        ActiveSupport::JSON.encode(message: error_message, success: false)
      )

      RestClient::Request
        .expects(:execute)
        .with(
          headers: { 'Content-Type': 'application/json' },
          method: :post,
          payload: {
            ingredients: [
              {
                quantity: 1,
                measureURI: "#{Edamam::MEASUREMENT_URI_PREFIX}gram",
                foodId: edamam_id
              }
            ]
          }.to_json,
          url: @nutrition_data_url
        )
        .raises(error)
      Rails.logger.expects(:error).with("Edamam UPC data error: #{error_message}")

      assert_nil(Edamam.get_data_from_upc(@upc), 'no data')
    end

    test('get data from upc - upc lookup response parse error') do
      mock_response = mock
      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @upc_lookup_url
        )
        .returns(mock_response)
      ActiveSupport::JSON.expects(:decode).with(mock_response).raises(JSON::ParserError)

      assert_nil(Edamam.get_data_from_upc(@upc), 'no data')
    end

    test('get data from upc - nutrition data response parse error') do
      edamam_id = 'edamam id'

      upc_lookup_response_body = {
        'hints' => [
          {
            'food' => { 'foodId' => edamam_id, 'label' => 'name' },
            'measures' => []
          }
        ]
      }

      RestClient::Request
        .expects(:execute)
        .with(
          headers: {},
          method: :get,
          payload: nil,
          url: @upc_lookup_url
        )
        .returns(upc_lookup_response_body.to_json)
      ActiveSupport::JSON
        .expects(:decode)
        .with(upc_lookup_response_body.to_json)
        .returns(upc_lookup_response_body)

      mock_response = mock
      RestClient::Request
        .expects(:execute)
        .with(
          headers: { 'Content-Type': 'application/json' },
          method: :post,
          payload: {
            ingredients: [
              {
                quantity: 1,
                measureURI: "#{Edamam::MEASUREMENT_URI_PREFIX}gram",
                foodId: edamam_id
              }
            ]
          }.to_json,
          url: @nutrition_data_url
        )
        .returns(mock_response)
      ActiveSupport::JSON.expects(:decode).with(mock_response).raises(JSON::ParserError)

      assert_nil(Edamam.get_data_from_upc(@upc), 'no data')
    end
  end
end
