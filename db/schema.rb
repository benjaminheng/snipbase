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

ActiveRecord::Schema.define(version: 20150630050709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "accepted"
  end

  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id", using: :btree
  add_index "group_members", ["user_id"], name: "index_group_members_on_user_id", using: :btree

  create_table "group_snippets", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "snippet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_snippets", ["group_id"], name: "index_group_snippets_on_group_id", using: :btree
  add_index "group_snippets", ["snippet_id"], name: "index_group_snippets_on_snippet_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "owner_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "snippet_files", force: :cascade do |t|
    t.string   "filename"
    t.string   "language"
    t.integer  "snippet_id"
    t.integer  "score",      default: 0
    t.string   "tags",                                array: true
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "content"
  end

  add_index "snippet_files", ["snippet_id"], name: "index_snippet_files_on_snippet_id", using: :btree
  add_index "snippet_files", ["tags"], name: "index_snippet_files_on_tags", using: :gin

  create_table "snippets", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.boolean  "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "snippets", ["user_id"], name: "index_snippets_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "is_admin"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "snippet_files", "snippets"
  add_foreign_key "snippets", "users"
end
