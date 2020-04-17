class AddInitialData < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.connection.execute(<<~SQL)
      INSERT INTO health_labels
        (created_at, id, name, updated_at)
      VALUES
        (CURRENT_TIMESTAMP, 1, 'Dairy-Free', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 2, 'Gluten-Free', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 3, 'Kosher', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 4, 'Peanut-Free', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 5, 'Pescatarian', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 6, 'Tree Nut-Free', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 7, 'Vegan', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 8, 'Vegetarian', CURRENT_TIMESTAMP)
    SQL

    ApplicationRecord.connection.execute(<<~SQL)
      INSERT INTO measurement_units
        (created_at, id, name, updated_at)
      VALUES
        (CURRENT_TIMESTAMP, 1, 'Gram', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 2, 'Kilogram', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 3, 'Ounce', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 4, 'Pound', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 5, 'Milliliter', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 6, 'Liter', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 7, 'Fluid Ounce', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 8, 'Pint', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 9, 'Quart', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 10, 'Gallon', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 11, 'Teaspoon', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 12, 'Tablespoon', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 13, 'Cup', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 14, 'Drop', CURRENT_TIMESTAMP),
        (CURRENT_TIMESTAMP, 15, 'Pinch', CURRENT_TIMESTAMP)
    SQL
  end

  def down
    ApplicationRecord.connection.execute('TRUNCATE TABLE health_labels')
    ApplicationRecord.connection.execute('TRUNCATE TABLE measurement_units')
  end
end
