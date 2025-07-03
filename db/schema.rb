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

ActiveRecord::Schema[8.0].define(version: 2025_07_03_140057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "creators", force: :cascade do |t|
    t.string "github_username", null: false
    t.string "telegram_channel", null: false
    t.string "name"
    t.string "avatar_url"
    t.string "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_username"], name: "index_creators_on_github_username", unique: true
    t.index ["telegram_channel"], name: "index_creators_on_telegram_channel", unique: true
  end

  create_table "github_activities", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.string "repo"
    t.integer "commits_count"
    t.string "timeframe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_github_activities_on_creator_id"
  end

  create_table "telegram_posts", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.integer "message_id"
    t.text "text"
    t.datetime "posted_at"
    t.string "timeframe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_telegram_posts_on_creator_id"
  end

  add_foreign_key "github_activities", "creators"
  add_foreign_key "telegram_posts", "creators"
end
