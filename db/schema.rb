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

ActiveRecord::Schema.define(version: 20150117234455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.string   "username"
    t.integer  "site_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "entrants"
    t.integer  "max_entrants"
    t.integer  "buy_in_in_cents"
    t.integer  "total_prizes_paid_in_cents"
    t.decimal  "average_score"
    t.string   "sport"
    t.string   "title"
    t.string   "game_type"
    t.string   "link"
    t.string   "site_contest_id"
    t.date     "completed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "contest_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "position"
    t.integer  "opponent_account_id"
    t.integer  "winnings_in_cents"
    t.integer  "entry_fee_in_cents",  null: false
    t.integer  "profit",              null: false
    t.decimal  "score",               null: false
    t.string   "site_entry_id"
    t.string   "opponent_username"
    t.string   "link"
    t.string   "sport"
    t.date     "entered_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contest_title"
    t.integer  "total_entries"
    t.integer  "site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
  end

end
