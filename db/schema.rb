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

ActiveRecord::Schema[8.0].define(version: 2025_05_27_174513) do
  create_table "movie_votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "movie_id", null: false
    t.string "vote_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_movie_votes_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_movie_votes_on_user_and_movie", unique: true
    t.index ["user_id"], name: "index_movie_votes_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_movies_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "movie_votes", "movies"
  add_foreign_key "movie_votes", "users"
  add_foreign_key "movies", "users"
  add_foreign_key "sessions", "users"
end
