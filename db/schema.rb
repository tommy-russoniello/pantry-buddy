# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_10_000000) do

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "item_families", force: :cascade do |t|
    t.integer "item_family_id"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_family_id"], name: "index_item_families_on_item_family_id"
    t.index ["name"], name: "index_item_families_on_name", unique: true
  end

  create_table "item_quantity_units", force: :cascade do |t|
    t.integer "grams", null: false
    t.string "item_id", null: false
    t.integer "quantity_unit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id", "quantity_unit_id"], name: "index_item_quantity_units_on_item_id_and_quantity_unit_id", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.decimal "added_sugar", null: false
    t.integer "brand_id"
    t.decimal "calcium", null: false
    t.decimal "calories", null: false
    t.decimal "carbs", null: false
    t.decimal "cholesterol", null: false
    t.decimal "fat", null: false
    t.decimal "fiber", null: false
    t.decimal "folate", null: false
    t.decimal "grams_per_tablespoon"
    t.decimal "iron", null: false
    t.integer "item_family_id"
    t.decimal "magnesium", null: false
    t.decimal "monounsaturated_fat", null: false
    t.string "name", null: false
    t.decimal "niacin", null: false
    t.decimal "phosphorus", null: false
    t.decimal "polyunsaturated_fat", null: false
    t.decimal "potassium", null: false
    t.decimal "protein", null: false
    t.decimal "riboflavin", null: false
    t.decimal "saturated_fat", null: false
    t.decimal "sodium", null: false
    t.decimal "sugar", null: false
    t.decimal "thiamin", null: false
    t.decimal "trans_fat", null: false
    t.integer "variety_id"
    t.decimal "vitamin_a", null: false
    t.decimal "vitamin_b6", null: false
    t.decimal "vitamin_b12", null: false
    t.decimal "vitamin_c", null: false
    t.decimal "vitamin_d", null: false
    t.decimal "vitamin_e", null: false
    t.decimal "vitamin_k", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_items_on_brand_id"
    t.index ["item_family_id", "variety_id", "brand_id"], name: "index_items_on_item_family_id_and_variety_id_and_brand_id", unique: true
    t.index ["variety_id"], name: "index_items_on_variety_id"
  end

  create_table "quantity_units", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"name\", \"type??\"", name: "index_quantity_units_on_name_and_type??", unique: true
  end

  create_table "varieties", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_varieties_on_name", unique: true
  end

  add_foreign_key "item_families", "item_families"
  add_foreign_key "item_quantity_units", "items"
  add_foreign_key "item_quantity_units", "quantity_units"
  add_foreign_key "items", "brands"
  add_foreign_key "items", "item_families"
  add_foreign_key "items", "varieties"
end
