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

ActiveRecord::Schema.define(version: 2020_09_02_023035) do

  create_table "breweries", force: :cascade do |t|
    t.string "name", null: false
    t.string "state", null: false
    t.string "brewery_type", null: false
    t.integer "search_id", null: false
    t.index ["search_id"], name: "index_breweries_on_search_id"
  end

  create_table "searches", force: :cascade do |t|
    t.string "state"
    t.string "brewery_type"
    t.index ["state", "brewery_type"], name: "index_searches_on_state_and_brewery_type", unique: true
  end

end
