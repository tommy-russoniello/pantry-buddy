class ItemHealthLabelTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @new_item_health_label = ItemHealthLabel.new(
      health_label_id: HealthLabel.ids[:vegetarian],
      item: @item
    )
  end

  tests_for('create') do
    test('valid create') do
      assert(@new_item_health_label.save, 'valid')
    end

    tests_for('invalid create') do
      test_invalid_changes(
        :@new_item_health_label,
        [
          [:health_label, nil, 'must exist'],
          [:item, nil, 'must exist']
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
        :@new_item_health_label,
        [
          [:health_label_id, HealthLabel.ids[:pescatarian], 'cannot be changed'],
          [:item, :@other_item, 'cannot be changed']
        ],
        save: true
      )
    end
  end
end
