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

ActiveRecord::Schema.define(version: 20201120115712) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "script_id"
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: :cascade do |t|
    t.string   "host",         limit: 255
    t.text     "result"
    t.integer  "script_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "memo"
    t.integer  "result_bytes"
  end

  create_table "scripts", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "body"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "guid",          limit: 255
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "nickname",   limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
