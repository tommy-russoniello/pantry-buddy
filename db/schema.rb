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

ActiveRecord::Schema.define(version: 2020_04_10_010000) do

  create_table "health_labels", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "item_health_labels", force: :cascade do |t|
    t.integer "health_label_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["health_label_id", "item_id"], name: "index_item_health_labels_on_health_label_id_and_item_id", unique: true
    t.index ["item_id", "health_label_id"], name: "index_item_health_labels_on_item_id_and_health_label_id"
  end

  create_table "item_measurement_units", force: :cascade do |t|
    t.integer "grams", null: false
    t.string "item_id", null: false
    t.integer "measurement_unit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id", "measurement_unit_id"], name: "ix_item_measurement_units_on_item_id_and_measurement_unit_id", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.decimal "added_sugar"
    t.decimal "calcium"
    t.decimal "calories"
    t.decimal "carbs"
    t.decimal "cholesterol"
    t.decimal "fat"
    t.decimal "fiber"
    t.decimal "grams_per_tablespoon"
    t.decimal "iron"
    t.decimal "magnesium"
    t.decimal "monounsaturated_fat"
    t.string "name", null: false
    t.decimal "niacin"
    t.decimal "phosphorus"
    t.decimal "polyunsaturated_fat"
    t.decimal "potassium"
    t.decimal "protein"
    t.decimal "riboflavin"
    t.decimal "saturated_fat"
    t.decimal "sodium"
    t.decimal "sugar"
    t.decimal "thiamin"
    t.decimal "trans_fat"
    t.decimal "vitamin_a"
    t.decimal "vitamin_b6"
    t.decimal "vitamin_b12"
    t.decimal "vitamin_c"
    t.decimal "vitamin_d"
    t.decimal "vitamin_e"
    t.decimal "vitamin_k"
    t.decimal "zinc"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "measurement_units", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "item_health_labels", "health_labels"
  add_foreign_key "item_health_labels", "items"
  add_foreign_key "item_measurement_units", "items"
  add_foreign_key "item_measurement_units", "measurement_units"
end
