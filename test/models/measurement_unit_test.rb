class MeasurementUnitTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @new_measurement_unit = MeasurementUnit.new(name: 'new name', uri_fragment_suffix: 'new')
  end

  tests_for('create') do
    test('valid create') do
      @new_measurement_unit.uri_fragment_suffix = nil

      assert(@new_measurement_unit.save, 'valid')
      assert_equal(
        'new_name',
        @new_measurement_unit.uri_fragment_suffix,
        'default uri fragment suffix'
      )
    end

    tests_for('invalid create') do
      test_invalid_changes(
        :@new_measurement_unit,
        [
          [:name, nil, 'can\'t be blank'],
          [:name, '', 'can\'t be blank'],
          [:name, :'@measurement_unit.name', 'has already been taken']
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
        :@measurement_unit,
        [
          [:name, 'updated name', 'cannot be changed'],
          [:uri_fragment_suffix, 'updated uri fragment suffix', 'cannot be changed']
        ]
      )
    end
  end
end
