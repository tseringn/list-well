# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_03_155929) do
  create_table "building_attributes", force: :cascade do |t|
    t.string "field_value"
    t.integer "building_id"
    t.integer "custom_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_building_attributes_on_building_id"
    t.index ["custom_field_id"], name: "index_building_attributes_on_custom_field_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.integer "year_built"
    t.decimal "lot_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "client_id"
    t.index ["client_id"], name: "index_buildings_on_client_id"
    t.index ["location_id"], name: "index_buildings_on_location_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
    t.index ["client_id"], name: "index_custom_fields_on_client_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "string"
    t.string "coordinates"
    t.string "jsonob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "building_attributes", "buildings"
  add_foreign_key "building_attributes", "custom_fields"
  add_foreign_key "buildings", "clients"
  add_foreign_key "buildings", "locations"
  add_foreign_key "custom_fields", "clients"
end
