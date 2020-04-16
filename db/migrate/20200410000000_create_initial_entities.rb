class CreateInitialEntities < ActiveRecord::Migration[6.0]
  def change
    create_table(:items) do |table|
      table.decimal(:added_sugar)
      table.decimal(:calcium)
      table.decimal(:calories)
      table.decimal(:carbs)
      table.decimal(:cholesterol)
      table.decimal(:fat)
      table.decimal(:fiber)
      table.decimal(:grams_per_tablespoon)
      table.decimal(:iron)
      table.decimal(:magnesium)
      table.decimal(:monounsaturated_fat)
      table.string(:name, null: false)
      table.decimal(:niacin)
      table.decimal(:phosphorus)
      table.decimal(:polyunsaturated_fat)
      table.decimal(:potassium)
      table.decimal(:protein)
      table.decimal(:riboflavin)
      table.decimal(:saturated_fat)
      table.decimal(:sodium)
      table.decimal(:sugar)
      table.decimal(:thiamin)
      table.decimal(:trans_fat)
      table.string(:upc)
      table.decimal(:vitamin_a)
      table.decimal(:vitamin_b6)
      table.decimal(:vitamin_b12)
      table.decimal(:vitamin_c)
      table.decimal(:vitamin_d)
      table.decimal(:vitamin_e)
      table.decimal(:vitamin_k)
      table.decimal(:zinc)
      table.timestamps
      table.index(%i[upc], unique: true)
    end

    create_table(:measurement_units) do |table|
      table.string(:name, null: false)
      table.timestamps
    end

    create_table(:item_measurement_units) do |table|
      table.integer(:grams, null: false)
      table.string(:item_id, null: false)
      table.bigint(:measurement_unit_id, null: false)
      table.timestamps
      table.index(
        %i[item_id measurement_unit_id],
        name: 'ix_item_measurement_units_on_item_id_and_measurement_unit_id',
        unique: true
      )
    end

    add_foreign_key(:item_measurement_units, :items)
    add_foreign_key(:item_measurement_units, :measurement_units)

    create_table(:health_labels) do |table|
      table.string(:name, null: false)
      table.timestamps
    end

    create_table(:item_health_labels) do |table|
      table.bigint(:health_label_id, null: false)
      table.bigint(:item_id, null: false)
      table.timestamps
      table.index(%i[health_label_id item_id], unique: true)
      table.index(%i[item_id health_label_id])
    end

    add_foreign_key(:item_health_labels, :health_labels)
    add_foreign_key(:item_health_labels, :items)
  end
end
