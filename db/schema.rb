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

ActiveRecord::Schema.define(version: 2021_01_05_000204) do

  create_table "event_store_events", force: :cascade do |t|
    t.string "event_id", limit: 36, null: false
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "valid_at", precision: 6
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.string "event_id", limit: 36, null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "flights", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "route_id", null: false
    t.datetime "departure_at"
    t.datetime "arrival_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
    t.index ["route_id"], name: "index_flights_on_route_id"
    t.index ["status"], name: "index_flights_on_status"
  end

  create_table "routes", force: :cascade do |t|
    t.string "name", null: false
    t.string "airline", null: false
    t.time "departure_at", null: false
    t.time "arrival_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["airline"], name: "index_routes_on_airline"
    t.index ["name"], name: "index_routes_on_name", unique: true
  end

  create_table "seat_reservation_passengers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "seat_reservations", force: :cascade do |t|
    t.integer "number"
    t.string "flight_no"
    t.string "event_id"
    t.string "flight_uuid"
    t.index ["flight_uuid"], name: "index_seat_reservations_on_flight_uuid"
  end

  add_foreign_key "flights", "routes"
end
