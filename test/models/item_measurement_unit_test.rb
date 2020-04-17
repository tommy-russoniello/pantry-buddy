class ItemMeasurementUnitTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @new_item_measurement_unit = ItemMeasurementUnit.new(
      grams: 1,
      item: @item,
      measurement_unit: @other_measurement_unit
    )
  end

  tests_for('create') do
    test('valid create') do
      assert(@new_item_measurement_unit.save, 'valid')
    end

    tests_for('invalid create') do
      test_invalid_changes(
        :@new_item_measurement_unit,
        [
          [:grams, nil, 'is not a number'],
          [:grams, 0, 'must be greater than 0'],
          [:item, nil, 'must exist'],
          [:measurement_unit, nil, 'must exist']
        ]
      )
    end
  end

  tests_for('update') do
    tests_for('valid update') do
      # No updatable attributes
    end

    tests_for('invalid update') do
      test_invalid_changes(
        :@item_measurement_unit,
        [
          [:grams, 99, 'cannot be changed'],
          [:item, :@other_item, 'cannot be changed'],
          [:measurement_unit, :@other_measurement_unit, 'cannot be changed']
        ]
      )
    end
  end
end
