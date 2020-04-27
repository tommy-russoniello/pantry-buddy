class ItemServiceTest < ActiveSupport::TestCase
  include FixtureSetup

  tests_for('find or create item from upc') do
    test('find or create item from upc - existing item - full data - fdc succeeded') do
      Fdc.expects(:get_data_from_upc).never
      Edamam.expects(:get_data_from_upc).never

      attributes = @item.attributes
      health_label_ids = @item.health_label_ids
      measurement_unit_ids = @item.measurement_unit_ids

      assert_equal(@item, ItemService.find_or_create_item_from_upc(@item.upc), 'existing item')

      @item.reload
      assert_equal(attributes, @item.attributes, 'attributes unchanged')
      assert_equal(health_label_ids, @item.health_label_ids, 'health labels unchanged')
      assert_equal(measurement_unit_ids, @item.measurement_unit_ids, 'measurement units unchanged')
    end

    test('find or create item from upc - existing item - full data - fdc failed within window') do
      Fdc.expects(:get_data_from_upc).never
      Edamam.expects(:get_data_from_upc).never

      @item.update!(
        nutrition_data_collection_failed_at:
          (ItemService::NUTRITION_DATA_COLLECTION_RETRY_DURATION - 1.hour).ago
      )

      attributes = @item.attributes
      health_label_ids = @item.health_label_ids
      measurement_unit_ids = @item.measurement_unit_ids

      assert_equal(@item, ItemService.find_or_create_item_from_upc(@item.upc), 'existing item')

      @item.reload
      assert_equal(attributes, @item.attributes, 'attributes unchanged')
      assert_equal(health_label_ids, @item.health_label_ids, 'health labels unchanged')
      assert_equal(measurement_unit_ids, @item.measurement_unit_ids, 'measurement units unchanged')
    end

    test('find or create item from upc - existing item - full data - fdc failed past window') do
      @item.update_columns(
        fdc_id: nil,
        nutrition_data_collection_failed_at:
          (ItemService::NUTRITION_DATA_COLLECTION_RETRY_DURATION + 1.hour).ago
      )

      health_label_ids = @item.health_label_ids
      measurement_unit_ids = @item.measurement_unit_ids

      fdc_data = {
        fdc_id: 'new fdc id',
        name: 'new name',
        nutrients: { calories: 99 }
      }
      Fdc.expects(:get_data_from_upc).with(@item.upc).returns(fdc_data)

      assert_equal(@item, ItemService.find_or_create_item_from_upc(@item.upc), 'existing item')

      @item.reload
      assert_equal(fdc_data[:fdc_id], @item.fdc_id, 'fdc id')
      assert_equal(fdc_data[:name], @item.name, 'name')
      assert_equal(fdc_data[:nutrients][:calories], @item.calories, 'calories')
      (Item.nutrients - [:calories]).each do |nutrient|
        assert_nil(@item.send(nutrient), "#{nutrient} removed")
      end

      assert_equal(health_label_ids, @item.health_label_ids, 'health labels unchanged')
      assert_equal(measurement_unit_ids, @item.measurement_unit_ids, 'measurement units unchanged')
    end

    test('find or create item from upc - existing item - only nutrition data') do
      @item.update_column(:edamam_id, nil)
      ItemHealthLabel.where(id: @item.item_health_label_ids).delete_all
      ItemMeasurementUnit.where(id: @item.item_measurement_unit_ids).delete_all

      health_labels = %i[dairy_free vegan]
      measurement_unit_grams = 2
      new_measurement_unit_data = {
        grams: 1,
        name: 'New Unit',
        uri_fragment_suffix: 'new'
      }
      edamam_data = {
        edamam_id: 'new edamam id',
        grams_per_tablespoon: 10.1,
        health_labels: health_labels.map { |health_label| health_label.to_s.upcase } +
          %w[SOMETHING_WE_DONT_CARE_ABOUT],
        measurement_units: {
          'Gram' => 'gram',
          @measurement_unit.name => @measurement_unit.uri_fragment_suffix,
          new_measurement_unit_data[:name] => new_measurement_unit_data[:uri_fragment_suffix]
        },
        name: 'the fdc name will get used over this'
      }
      Edamam.expects(:get_data_from_upc).with(@item.upc, nutrients: false).returns(edamam_data)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          edamam_id: edamam_data[:edamam_id],
          measurement: @measurement_unit.uri_fragment_suffix
        )
        .returns(measurement_unit_grams)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          edamam_id: edamam_data[:edamam_id],
          measurement: new_measurement_unit_data[:uri_fragment_suffix]
        )
        .returns(new_measurement_unit_data[:grams])

      assert_equal(@item, ItemService.find_or_create_item_from_upc(@item.upc), 'existing item')

      new_measurement_unit = MeasurementUnit.find_by(new_measurement_unit_data.except(:grams))
      assert(new_measurement_unit, 'new measurement unit created')

      assert_equal(
        HealthLabel.ids.values_at(*health_labels),
        @item.health_label_ids,
        'health label ids'
      )

      item_measurement_unit_data = [
        [@measurement_unit.id, measurement_unit_grams],
        [new_measurement_unit.id, new_measurement_unit_data[:grams]]
      ]
      assert_equal(
        item_measurement_unit_data.sort_by(&:first),
        @item.item_measurement_units.pluck(:measurement_unit_id, :grams).sort_by(&:first),
        'item measurement_units'
      )
    end

    test('find or create item from upc - new item - fdc') do
      upc = 'new upc'
      health_labels = %i[dairy_free vegan]
      measurement_unit_grams = 2
      new_measurement_unit_data = {
        grams: 1,
        name: 'New Unit',
        uri_fragment_suffix: 'new'
      }
      fdc_data = {
        fdc_id: 'new fdc id',
        name: 'new item',
        nutrients: { calories: 5, carbs: 0.55, fat: 0.3, protein: 0.15 }
      }
      edamam_data = {
        edamam_id: 'new edamam id',
        grams_per_tablespoon: 10.1,
        health_labels: health_labels.map { |health_label| health_label.to_s.upcase } +
          %w[SOMETHING_WE_DONT_CARE_ABOUT],
        measurement_units: {
          'Gram' => 'gram',
          @measurement_unit.name => @measurement_unit.uri_fragment_suffix,
          new_measurement_unit_data[:name] => new_measurement_unit_data[:uri_fragment_suffix]
        },
        name: 'the fdc name will get used over this'
      }

      Fdc.expects(:get_data_from_upc).with(upc).returns(fdc_data)
      Edamam.expects(:get_data_from_upc).with(upc, nutrients: false).returns(edamam_data)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          edamam_id: edamam_data[:edamam_id],
          measurement: @measurement_unit.uri_fragment_suffix
        )
        .returns(measurement_unit_grams)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          edamam_id: edamam_data[:edamam_id],
          measurement: new_measurement_unit_data[:uri_fragment_suffix]
        )
        .returns(new_measurement_unit_data[:grams])

      ItemService.find_or_create_item_from_upc(upc)

      new_measurement_unit = MeasurementUnit.find_by(new_measurement_unit_data.except(:grams))
      assert(new_measurement_unit, 'new measurement unit created')

      new_item = Item.find_by(
        grams_per_tablespoon: edamam_data[:grams_per_tablespoon],
        name: fdc_data[:name],
        upc: upc,
        **fdc_data[:nutrients]
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

    test('find or create item from upc - new item - edamam') do
      upc = 'new upc'
      health_labels = %i[dairy_free vegan]
      measurement_unit_grams = 2
      new_measurement_unit_data = {
        grams: 1,
        name: 'New Unit',
        uri_fragment_suffix: 'new'
      }
      edamam_data = {
        edamam_id: 'new edamam id',
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

      Fdc.expects(:get_data_from_upc).with(upc).returns(nil)
      Edamam.expects(:get_data_from_upc).with(upc, nutrients: true).returns(edamam_data)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          edamam_id: edamam_data[:edamam_id],
          measurement: @measurement_unit.uri_fragment_suffix
        )
        .returns(measurement_unit_grams)
      Edamam
        .expects(:get_grams_per_measurement_unit)
        .with(
          edamam_id: edamam_data[:edamam_id],
          measurement: new_measurement_unit_data[:uri_fragment_suffix]
        )
        .returns(new_measurement_unit_data[:grams])

      ItemService.find_or_create_item_from_upc(upc)

      new_measurement_unit = MeasurementUnit.find_by(new_measurement_unit_data.except(:grams))
      assert(new_measurement_unit, 'new measurement unit created')

      new_item = Item.find_by(
        grams_per_tablespoon: edamam_data[:grams_per_tablespoon],
        name: edamam_data[:name],
        upc: upc,
        **edamam_data[:nutrients]
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

    test('find or create item from upc - error') do
      upc = 'new upc'
      new_measurement_unit_data = {
        name: 'New Unit',
        uri_fragment_suffix: 'new'
      }
      edamam_data = {
        edamam_id: 'new edamam id',
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

      Fdc.expects(:get_data_from_upc).with(upc).returns(nil)
      Edamam.expects(:get_data_from_upc).with(upc, nutrients: true).returns(edamam_data)
      Edamam.stubs(:get_grams_per_measurement_unit).returns(1)

      error = StandardError.new
      ItemMeasurementUnit.stubs(:create!).raises(error)

      assert_nil(ItemService.find_or_create_item_from_upc(upc), 'nothing found or created')

      assert_not(
        MeasurementUnit.where(new_measurement_unit_data).exists?,
        'no measurement unit created'
      )

      assert_not(Item.where(upc: upc).exists?, 'no item created')
    end

    test('find or create item from upc - no data') do
      upc = 'new upc'
      Fdc.expects(:get_data_from_upc).with(upc).returns(nil)
      Edamam.expects(:get_data_from_upc).with(upc, nutrients: true).returns(nil)

      ItemService.find_or_create_item_from_upc(upc)

      assert_not(Item.where(upc: upc).exists?, 'no item created')
    end
  end
end
