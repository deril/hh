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

ActiveRecord::Schema.define(version: 20160103093132) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",       null: false
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["group_id"], name: "index_groups_on_group_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "warn_id"
    t.string   "image_hash",         limit: 1024
    t.string   "alt"
  end

  add_index "images", ["warn_id"], name: "index_images_on_warn_id", using: :btree

  create_table "images_tags", force: true do |t|
    t.integer "tag_id"
    t.integer "image_id"
  end

  add_index "images_tags", ["image_id"], name: "index_images_tags_on_image_id", using: :btree
  add_index "images_tags", ["tag_id"], name: "index_images_tags_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",       limit: 40
    t.integer  "count",                 default: 0
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["group_id"], name: "index_tags_on_group_id", using: :btree

  create_table "warns", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
