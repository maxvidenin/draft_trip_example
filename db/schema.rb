# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151215105046) do

  create_table "itineraries", force: :cascade do |t|
    t.string   "name"
    t.string   "string"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "trip_content_id"
  end

  add_index "itineraries", ["trip_content_id"], name: "index_itineraries_on_trip_content_id"

  create_table "media", force: :cascade do |t|
    t.string   "image_name"
    t.string   "mediable_type"
    t.integer  "mediable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string   "transaction_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "trip_contents", force: :cascade do |t|
    t.integer  "trip_id"
    t.string   "title"
    t.text     "description"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "trip_contents", ["trip_id"], name: "index_trip_contents_on_trip_id"

  create_table "trip_payments", force: :cascade do |t|
    t.integer  "trip_id"
    t.integer  "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "published",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "slug"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
