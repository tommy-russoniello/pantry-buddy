class MeasurementUnitTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @new_measurement_unit = MeasurementUnit.new(name: 'new measure unit')
  end

  tests_for('create') do
    test('valid create') do
      assert(@new_measurement_unit.save, 'valid')
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
          [:name, 'updated name', 'cannot be changed']
        ]
      )
    end
  end
end
