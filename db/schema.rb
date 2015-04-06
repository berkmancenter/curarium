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

ActiveRecord::Schema.define(version: 20150323190505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.string   "activity_type"
    t.string   "body"
    t.integer  "activitiable_id"
    t.string   "activitiable_type"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["activitiable_id", "activitiable_type"], name: "index_activities_on_activitiable_id_and_activitiable_type", using: :btree

  create_table "amendments", force: true do |t|
    t.hstore   "previous"
    t.hstore   "amended"
    t.integer  "user_id"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "amendments", ["user_id"], name: "index_amendments_on_user_id", using: :btree
  add_index "amendments", ["work_id"], name: "index_amendments_on_work_id", using: :btree

  create_table "annotations", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
    t.string   "title"
    t.string   "tags"
    t.text     "body"
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.string   "image_url"
    t.integer  "tray_item_id"
    t.string   "thumbnail_url"
  end

  add_index "annotations", ["image_id"], name: "index_annotations_on_image_id", using: :btree
  add_index "annotations", ["tray_item_id"], name: "index_annotations_on_tray_item_id", using: :btree

  create_table "circle_collections", force: true do |t|
    t.integer  "circle_id"
    t.integer  "collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "circles", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "privacy",     default: "private"
  end

  create_table "circles_users", id: false, force: true do |t|
    t.integer "circle_id"
    t.integer "user_id"
  end

  add_index "circles_users", ["circle_id"], name: "index_circles_users_on_circle_id", using: :btree
  add_index "circles_users", ["user_id"], name: "index_circles_users_on_user_id", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.text     "description"
    t.boolean  "approved"
    t.json     "configuration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin",         default: [], array: true
    t.json     "associations"
    t.integer  "size"
    t.string   "source"
    t.boolean  "importing"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.text     "image_url"
    t.text     "thumbnail_url"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tray_item_id"
  end

  add_index "images", ["tray_item_id"], name: "index_images_on_tray_item_id", using: :btree
  add_index "images", ["work_id"], name: "index_images_on_work_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "type"
    t.integer  "resource"
    t.integer  "section_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.integer  "users",      default: [],                                                                                 array: true
    t.integer  "admins",     default: [],                                                                                 array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "resources",  default: {"Collection"=>[], "Spotlight"=>[], "Tray"=>[], "Visualization"=>[], "Record"=>[]}
    t.string   "title"
  end

  create_table "spotlights", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "waku_url"
    t.string   "waku_id"
    t.string   "privacy",    default: "private"
    t.integer  "circle_id"
  end

  add_index "spotlights", ["circle_id"], name: "index_spotlights_on_circle_id", using: :btree
  add_index "spotlights", ["user_id"], name: "index_spotlights_on_user_id", using: :btree

  create_table "tray_items", force: true do |t|
    t.integer  "tray_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "annotation_id"
  end

  add_index "tray_items", ["annotation_id"], name: "index_tray_items_on_annotation_id", using: :btree
  add_index "tray_items", ["image_id"], name: "index_tray_items_on_image_id", using: :btree
  add_index "tray_items", ["tray_id"], name: "index_tray_items_on_tray_id", using: :btree

  create_table "trays", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super",      default: false
    t.string   "slug"
    t.text     "bio"
  end

  create_table "works", force: true do |t|
    t.json     "original"
    t.hstore   "parsed"
    t.integer  "collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_identifier"
    t.text     "title"
  end

end
