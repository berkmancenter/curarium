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

ActiveRecord::Schema.define(version: 20140102041606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "collections", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.text     "description"
    t.boolean  "approved"
    t.json     "configuration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin",         default: [], array: true
    t.json     "properties"
    t.json     "associations"
  end

  create_table "records", force: true do |t|
    t.json     "original"
    t.hstore   "parsed"
    t.integer  "collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "users",      default: [], array: true
    t.string   "admins",     default: [], array: true
    t.integer  "spotlights", default: [], array: true
    t.integer  "trays",      default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlights", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "type"
    t.integer  "records",    default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
