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

ActiveRecord::Schema[7.2].define(version: 2025_05_19_133228) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "diary_entries", force: :cascade do |t|
    t.date "date", null: false
    t.text "good_things", null: false
    t.text "reflection", null: false
    t.text "notes"
    t.integer "happiness_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["date"], name: "index_diary_entries_on_date", unique: true
    t.index ["user_id", "date"], name: "index_diary_entries_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_diary_entries_on_user_id"
  end

  create_table "happiness_items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "weight"
    t.boolean "satisfied"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "happiness_scores", force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "diary_entries", "users"
end
