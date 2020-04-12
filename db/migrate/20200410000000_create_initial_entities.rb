class CreateInitialEntities < ActiveRecord::Migration[6.0]
  def change
    create_table(:item_families) do |table|
      table.bigint(:item_family_id)
      table.string(:name, null: false)
      table.timestamps
      table.index(%i[item_family_id])
      table.index(%i[name], unique: true)
    end

    add_foreign_key(:item_families, :item_families)

    create_table(:varieties) do |table|
      table.string(:name, null: false)
      table.timestamps
      table.index(%i[name], unique: true)
    end

    create_table(:brands) do |table|
      table.string(:name, null: false)
      table.timestamps
      table.index(%i[name], unique: true)
    end

    create_table(:items) do |table|
      table.decimal(:added_sugar, null: false)
      table.bigint(:brand_id)
      table.decimal(:calcium, null: false)
      table.decimal(:calories, null: false)
      table.decimal(:carbs, null: false)
      table.decimal(:cholesterol, null: false)
      table.decimal(:fat, null: false)
      table.decimal(:fiber, null: false)
      table.decimal(:folate, null: false)
      table.decimal(:grams_per_tablespoon)
      table.decimal(:iron, null: false)
      table.bigint(:item_family_id)
      table.decimal(:magnesium, null: false)
      table.decimal(:monounsaturated_fat, null: false)
      table.string(:name, null: false)
      table.decimal(:niacin, null: false)
      table.decimal(:phosphorus, null: false)
      table.decimal(:polyunsaturated_fat, null: false)
      table.decimal(:potassium, null: false)
      table.decimal(:protein, null: false)
      table.decimal(:riboflavin, null: false)
      table.decimal(:saturated_fat, null: false)
      table.decimal(:sodium, null: false)
      table.decimal(:sugar, null: false)
      table.decimal(:thiamin, null: false)
      table.decimal(:trans_fat, null: false)
      table.bigint(:variety_id)
      table.decimal(:vitamin_a, null: false)
      table.decimal(:vitamin_b6, null: false)
      table.decimal(:vitamin_b12, null: false)
      table.decimal(:vitamin_c, null: false)
      table.decimal(:vitamin_d, null: false)
      table.decimal(:vitamin_e, null: false)
      table.decimal(:vitamin_k, null: false)
      table.timestamps
      table.index(%i[brand_id])
      table.index(%i[item_family_id variety_id brand_id], unique: true)
      table.index(%i[variety_id])
    end

    add_foreign_key(:items, :brands)
    add_foreign_key(:items, :item_families)
    add_foreign_key(:items, :varieties)

    create_table(:quantity_units) do |table|
      table.string(:name, null: false)
      ###type?
      table.timestamps
      table.index(%i[name type??], unique: true)
    end

    create_table(:item_quantity_units) do |table|
      table.integer(:grams, null: false)
      table.string(:item_id, null: false)
      table.bigint(:quantity_unit_id, null: false)
      table.timestamps
      table.index(%i[item_id quantity_unit_id], unique: true)
    end

    add_foreign_key(:item_quantity_units, :items)
    add_foreign_key(:item_quantity_units, :quantity_units)
  end
end
