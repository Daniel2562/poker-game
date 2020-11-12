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

ActiveRecord::Schema.define(version: 2018_09_01_185230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "request_id"
    t.integer "step"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_comments_on_request_id"
  end

  create_table "hands", force: :cascade do |t|
    t.integer "level"
    t.integer "level_time"
    t.integer "hand_limit"
    t.integer "small_blind"
    t.integer "big_blind"
    t.integer "ante"
    t.integer "players_dealt"
    t.string "position"
    t.integer "start_pot"
    t.integer "start_stack"
    t.integer "final_stack"
    t.integer "state"
    t.string "hole_cards", default: [], array: true
    t.string "table_cards", default: [], array: true
    t.string "villains_json"
    t.string "steps_json"
    t.bigint "session_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_hands_on_session_id"
    t.index ["user_id"], name: "index_hands_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.boolean "viewed"
    t.boolean "resolved"
    t.boolean "accepted"
    t.string "summary"
    t.string "payment"
    t.integer "pro_id"
    t.bigint "user_id"
    t.bigint "hand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hand_id"], name: "index_requests_on_hand_id"
    t.index ["pro_id"], name: "index_requests_on_pro_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "title"
    t.string "game"
    t.string "kind"
    t.integer "level_time"
    t.integer "small_blind"
    t.integer "big_blind"
    t.integer "ante"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.string "actor"
    t.string "action"
    t.integer "amount"
    t.integer "stack"
    t.string "title"
    t.string "comment"
    t.bigint "hand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hand_id"], name: "index_steps_on_hand_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "avatar"
    t.string "game_kinds", default: [], array: true
    t.boolean "pro"
    t.string "ios_iap_id"
    t.string "android_iap_id"
    t.string "promo_code"
    t.string "applied_promo_code"
    t.integer "remaining_promo_requests"
    t.string "queen_salt"
    t.string "queen_hash"
    t.string "password_digest"
    t.string "auth_token"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string "reset_password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["android_iap_id"], name: "index_users_on_android_iap_id"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["ios_iap_id"], name: "index_users_on_ios_iap_id"
    t.index ["pro"], name: "index_users_on_pro"
    t.index ["promo_code"], name: "index_users_on_promo_code"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "villains", force: :cascade do |t|
    t.string "profile"
    t.string "position"
    t.integer "start_stack"
    t.bigint "hand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hand_id"], name: "index_villains_on_hand_id"
  end

  add_foreign_key "comments", "requests"
  add_foreign_key "hands", "sessions"
  add_foreign_key "hands", "users"
  add_foreign_key "requests", "hands"
  add_foreign_key "requests", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "steps", "hands"
  add_foreign_key "villains", "hands"
end
