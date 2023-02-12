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

ActiveRecord::Schema[7.0].define(version: 2022_12_25_223532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "place_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_favorites_on_pet_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pet_areas", force: :cascade do |t|
    t.bigint "pet_id"
    t.bigint "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_pet_areas_on_area_id"
    t.index ["pet_id", "area_id"], name: "index_pet_areas_on_pet_id_and_area_id", unique: true
    t.index ["pet_id"], name: "index_pet_areas_on_pet_id"
  end

  create_table "pet_images", force: :cascade do |t|
    t.string "photo"
    t.bigint "pet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_pet_images_on_pet_id"
  end

  create_table "pets", force: :cascade do |t|
    t.integer "category"
    t.string "petname"
    t.text "introduction"
    t.integer "gender", default: 0, null: false
    t.integer "age", default: 0, null: false
    t.integer "classification", default: 0, null: false
    t.integer "castration", default: 0, null: false
    t.integer "vaccination", default: 0, null: false
    t.integer "recruitment_status", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age"], name: "index_pets_on_age"
    t.index ["category"], name: "index_pets_on_category"
    t.index ["classification"], name: "index_pets_on_classification"
    t.index ["gender"], name: "index_pets_on_gender"
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.datetime "birthday"
    t.string "breeding_experience"
    t.string "avatar"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "owner_id", null: false
    t.bigint "pet_id", null: false
    t.integer "recruitment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
    t.index ["pet_id"], name: "index_rooms_on_pet_id"
    t.index ["user_id", "owner_id", "pet_id"], name: "index_rooms_on_user_id_and_owner_id_and_pet_id", unique: true
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorites", "pets"
  add_foreign_key "favorites", "users"
  add_foreign_key "pet_areas", "areas"
  add_foreign_key "pet_areas", "pets"
  add_foreign_key "pet_images", "pets"
  add_foreign_key "pets", "users"
  add_foreign_key "rooms", "pets"
  add_foreign_key "rooms", "users"
  add_foreign_key "rooms", "users", column: "owner_id"
end
