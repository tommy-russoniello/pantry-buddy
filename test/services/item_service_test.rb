class ItemServiceTest < ActiveSupport::TestCase
  include FixtureSetup

  tests_for('create item from upc') do
    test('create item from upc - success') do
      upc = 'new upc'
      health_labels = %i[dairy_free vegan]
      measurement_unit_grams = 2
      new_measurement_unit_data = {
        grams: 1,
        name: 'New Unit',
        uri_fragment_suffix: 'new'
      }
      data = {
        food_id: 'food id',
        grams_per_tablespoon: 10.1,
        health_labels: health_labels.map { |health_label| health_label.to_s.upcase } +
          %w[SOMETHING_WE_DONT_CARE_ABOUT],
        measurement_units: {
          'Gram' => 'gram',
          @measurement_unit.name => @measurement_unit.uri_fragment_suffix,
          new_measurement_unit_data[:name] => new_measurement_unit_data[:uri_fragment_suffix]
        },
        name: 'new item',
        nutrients: { calories: 5, carbs: 0.55, fat: 0.3, protein: 0.15 }
      }

      Edamam.expects(:get_nutrition_data_from_upc).with(upc).returns(data)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(food_id: data[:food_id], measurement: @measurement_unit.uri_fragment_suffix)
        .returns(measurement_unit_grams)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          food_id: data[:food_id],
          measurement: new_measurement_unit_data[:uri_fragment_suffix]
        )
        .returns(new_measurement_unit_data[:grams])

      ItemService.create_item_from_upc(upc)

      new_measurement_unit = MeasurementUnit.find_by(new_measurement_unit_data.except(:grams))
      assert(new_measurement_unit, 'new measurement unit created')

      new_item = Item.find_by(
        grams_per_tablespoon: data[:grams_per_tablespoon],
        name: data[:name],
        upc: upc,
        **data[:nutrients]
      )
      assert(new_item, 'new item created')
      assert_equal(
        HealthLabel.ids.values_at(*health_labels),
        new_item.health_label_ids,
        'health label ids'
      )

      item_measurement_unit_data = [
        [@measurement_unit.id, measurement_unit_grams],
        [new_measurement_unit.id, new_measurement_unit_data[:grams]]
      ]
      assert_equal(
        item_measurement_unit_data.sort_by(&:first),
        new_item.item_measurement_units.pluck(:measurement_unit_id, :grams).sort_by(&:first),
        'item measurement_units'
      )
    end

    test('create item from upc - error') do
      upc = 'new upc'
      new_measurement_unit_data = {
        name: 'New Unit',
        uri_fragment_suffix: 'new'
      }
      data = {
        food_id: 'food id',
        grams_per_tablespoon: 10.1,
        health_labels: %i[dairy_free vegan],
        measurement_units: {
          'Gram' => 'gram',
          @measurement_unit.name => @measurement_unit.uri_fragment_suffix,
          new_measurement_unit_data[:name] => new_measurement_unit_data[:uri_fragment_suffix]
        },
        name: 'new item',
        nutrients: { calories: 5, carbs: 0.55, fat: 0.3, protein: 0.15 }
      }

      Edamam.expects(:get_nutrition_data_from_upc).with(upc).returns(data)
      Edamam.stubs(:get_grams_per_measurement_unit).returns(1)

      error = StandardError.new
      ItemMeasurementUnit.stubs(:create!).raises(error)

      assert_raises(error.class) { ItemService.create_item_from_upc(upc) }

      assert_not(
        MeasurementUnit.where(new_measurement_unit_data).exists?,
        'no measurement unit created'
      )

      assert_not(Item.where(upc: upc).exists?, 'no item created')
    end

    test('create item from upc - no data') do
      upc = 'new upc'
      Edamam.expects(:get_nutrition_data_from_upc).with(upc).returns(nil)

      ItemService.create_item_from_upc(upc)

      assert_not(Item.where(upc: upc).exists?, 'no item created')
    end
  end
end
