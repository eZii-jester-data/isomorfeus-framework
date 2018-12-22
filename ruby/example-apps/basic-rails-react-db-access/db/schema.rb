# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_31_202503) do

  create_table "electric_cars", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.integer "power"
    t.integer "max_speed"
    t.integer "battery_capacity"
    t.integer "real_range"
    t.integer "advertised_range"
    t.integer "price"
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
