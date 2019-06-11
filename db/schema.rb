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

ActiveRecord::Schema.define(version: 2019_06_07_181433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.string "spotify_id"
    t.string "spotify_url"
    t.string "href"
    t.string "uri"
    t.string "image_url_small"
    t.string "image_url_medium"
    t.string "image_url_large"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artist_genres", force: :cascade do |t|
    t.bigint "artist_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artist_genres_on_artist_id"
    t.index ["genre_id"], name: "index_artist_genres_on_genre_id"
  end

  create_table "artist_tracks", force: :cascade do |t|
    t.bigint "artist_id"
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artist_tracks_on_artist_id"
    t.index ["track_id"], name: "index_artist_tracks_on_track_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "spotify_url"
    t.string "href"
    t.string "spotify_id"
    t.string "uri"
    t.string "image_url_small"
    t.string "image_url_medium"
    t.string "image_url_large"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.integer "duration_ms"
    t.boolean "explicit"
    t.string "spotify_url"
    t.string "href"
    t.string "spotify_id"
    t.string "preview_url"
    t.string "uri"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
  end

  create_table "user_tracks", force: :cascade do |t|
    t.datetime "added_at"
    t.bigint "user_id"
    t.bigint "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_user_tracks_on_track_id"
    t.index ["user_id"], name: "index_user_tracks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "access_token"
    t.string "refresh_token"
    t.string "spotify_url"
    t.string "profile_img_url"
    t.string "href"
    t.string "uri"
    t.boolean "full_library", default: false
    t.datetime "last_library_update"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "followers"
  end

  add_foreign_key "artist_genres", "artists"
  add_foreign_key "artist_genres", "genres"
  add_foreign_key "artist_tracks", "artists"
  add_foreign_key "artist_tracks", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "user_tracks", "tracks"
  add_foreign_key "user_tracks", "users"
end
