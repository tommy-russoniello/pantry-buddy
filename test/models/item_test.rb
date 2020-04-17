class ItemTest < ActiveSupport::TestCase
  include FixtureSetup

  def setup
    super

    @new_item = Item.new(name: 'new item')
  end

  tests_for('create') do
    tests_for('valid create') do
      test('valid create - required fields') do
        assert(@new_item.save, 'valid')
      end

      test('valid create - all fields') do
        @new_item.assign_attributes(
          added_sugar: 1,
          calcium: 1,
          calories: 100,
          carbs: 1,
          cholesterol: 1,
          fat: 1,
          fiber: 1,
          iron: 1,
          magnesium: 1,
          monounsaturated_fat: 1,
          niacin: 1,
          phosphorus: 1,
          polyunsaturated_fat: 1,
          potassium: 1,
          protein: 1,
          riboflavin: 1,
          saturated_fat: 1,
          sodium: 1,
          sugar: 1,
          thiamin: 1,
          trans_fat: 1,
          upc: 'new upc',
          vitamin_a: 1,
          vitamin_b6: 1,
          vitamin_b12: 1,
          vitamin_c: 1,
          vitamin_d: 1,
          vitamin_e: 1,
          vitamin_k: 1
        )

        assert(@new_item.save, 'valid')
      end
    end

    tests_for('invalid create') do
      test_invalid_changes(
        :@new_item,
        [
          [:added_sugar, -1, 'must be greater than or equal to 0'],
          [:calcium, -1, 'must be greater than or equal to 0'],
          [:calories, -1, 'must be greater than or equal to 0'],
          [:carbs, -1, 'must be greater than or equal to 0'],
          [:cholesterol, -1, 'must be greater than or equal to 0'],
          [:fat, -1, 'must be greater than or equal to 0'],
          [:fiber, -1, 'must be greater than or equal to 0'],
          [:iron, -1, 'must be greater than or equal to 0'],
          [:magnesium, -1, 'must be greater than or equal to 0'],
          [:monounsaturated_fat, -1, 'must be greater than or equal to 0'],
          [:name, nil, 'can\'t be blank'],
          [:name, '', 'can\'t be blank'],
          [:niacin, -1, 'must be greater than or equal to 0'],
          [:phosphorus, -1, 'must be greater than or equal to 0'],
          [:polyunsaturated_fat, -1, 'must be greater than or equal to 0'],
          [:potassium, -1, 'must be greater than or equal to 0'],
          [:protein, -1, 'must be greater than or equal to 0'],
          [:riboflavin, -1, 'must be greater than or equal to 0'],
          [:saturated_fat, -1, 'must be greater than or equal to 0'],
          [:sodium, -1, 'must be greater than or equal to 0'],
          [:sugar, -1, 'must be greater than or equal to 0'],
          [:thiamin, -1, 'must be greater than or equal to 0'],
          [:trans_fat, -1, 'must be greater than or equal to 0'],
          [:vitamin_a, -1, 'must be greater than or equal to 0'],
          [:vitamin_b6, -1, 'must be greater than or equal to 0'],
          [:vitamin_b12, -1, 'must be greater than or equal to 0'],
          [:vitamin_c, -1, 'must be greater than or equal to 0'],
          [:vitamin_d, -1, 'must be greater than or equal to 0'],
          [:vitamin_e, -1, 'must be greater than or equal to 0'],
          [:vitamin_k, -1, 'must be greater than or equal to 0']
        ]
      )
    end
  end

  tests_for('update') do
    tests_for('valid update') do
      {
        added_sugar: 99,
        calcium: 99,
        calories: 99,
        carbs: 99,
        cholesterol: 99,
        fat: 99,
        fiber: 99,
        iron: 99,
        magnesium: 99,
        monounsaturated_fat: 99,
        niacin: 99,
        phosphorus: 99,
        polyunsaturated_fat: 99,
        potassium: 99,
        protein: 99,
        riboflavin: 99,
        saturated_fat: 99,
        sodium: 99,
        sugar: 99,
        thiamin: 99,
        trans_fat: 99,
        vitamin_a: 99,
        vitamin_b6: 99,
        vitamin_b12: 99,
        vitamin_c: 99,
        vitamin_d: 99,
        vitamin_e: 99,
        vitamin_k: 99
      }.each do |attribute, value|
        test("valid update - #{attribute}") do
          @item.send("#{attribute}=", value)

          assert(@item.save, 'valid')
        end
      end
    end

    tests_for('invalid update') do
      test_invalid_changes(
        :@item,
        [
          [:added_sugar, -1, 'must be greater than or equal to 0'],
          [:calcium, -1, 'must be greater than or equal to 0'],
          [:calories, -1, 'must be greater than or equal to 0'],
          [:carbs, -1, 'must be greater than or equal to 0'],
          [:cholesterol, -1, 'must be greater than or equal to 0'],
          [:fat, -1, 'must be greater than or equal to 0'],
          [:fiber, -1, 'must be greater than or equal to 0'],
          [:iron, -1, 'must be greater than or equal to 0'],
          [:magnesium, -1, 'must be greater than or equal to 0'],
          [:monounsaturated_fat, -1, 'must be greater than or equal to 0'],
          [:name, 'updated name', 'cannot be changed'],
          [:niacin, -1, 'must be greater than or equal to 0'],
          [:phosphorus, -1, 'must be greater than or equal to 0'],
          [:polyunsaturated_fat, -1, 'must be greater than or equal to 0'],
          [:potassium, -1, 'must be greater than or equal to 0'],
          [:protein, -1, 'must be greater than or equal to 0'],
          [:riboflavin, -1, 'must be greater than or equal to 0'],
          [:saturated_fat, -1, 'must be greater than or equal to 0'],
          [:sodium, -1, 'must be greater than or equal to 0'],
          [:sugar, -1, 'must be greater than or equal to 0'],
          [:thiamin, -1, 'must be greater than or equal to 0'],
          [:trans_fat, -1, 'must be greater than or equal to 0'],
          [:upc, 'updated upc', 'cannot be changed'],
          [:vitamin_a, -1, 'must be greater than or equal to 0'],
          [:vitamin_b6, -1, 'must be greater than or equal to 0'],
          [:vitamin_b12, -1, 'must be greater than or equal to 0'],
          [:vitamin_c, -1, 'must be greater than or equal to 0'],
          [:vitamin_d, -1, 'must be greater than or equal to 0'],
          [:vitamin_e, -1, 'must be greater than or equal to 0'],
          [:vitamin_k, -1, 'must be greater than or equal to 0']
        ]
      )
    end
  end
end
