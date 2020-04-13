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
      table.decimal(:added_sugar)
      table.bigint(:brand_id)
      table.decimal(:calcium)
      table.decimal(:calories)
      table.decimal(:carbs)
      table.decimal(:cholesterol)
      table.decimal(:fat)
      table.decimal(:fiber)
      table.decimal(:folate)
      table.decimal(:grams_per_tablespoon)
      table.decimal(:iron)
      table.bigint(:item_family_id)
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
      table.bigint(:variety_id)
      table.decimal(:vitamin_a)
      table.decimal(:vitamin_b6)
      table.decimal(:vitamin_b12)
      table.decimal(:vitamin_c)
      table.decimal(:vitamin_d)
      table.decimal(:vitamin_e)
      table.decimal(:vitamin_k)
      table.decimal(:zinc)
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
