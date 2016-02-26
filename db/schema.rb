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

ActiveRecord::Schema.define(version: 20100306004526) do

  create_table "client_package_histories", force: :cascade do |t|
    t.integer  "client_id",              null: false
    t.integer  "package_id",             null: false
    t.string   "action",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user",       limit: 255
    t.string   "comment",    limit: 255
  end

  create_table "client_packages", force: :cascade do |t|
    t.integer "client_id",              null: false
    t.integer "package_id",             null: false
    t.string  "tpkg_home",  limit: 255
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string "name",            limit: 255, null: false
    t.string "version",         limit: 255
    t.string "os",              limit: 255
    t.string "arch",            limit: 255
    t.string "package_version", limit: 255
    t.string "maintainer",      limit: 255, null: false
    t.text   "description"
    t.string "filename",        limit: 255
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size"
    t.string   "uploader",            limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                     limit: 40
    t.string   "name",                      limit: 100, default: ""
    t.string   "email",                     limit: 100
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           limit: 40
    t.datetime "activated_at"
    t.string   "state",                     limit: 255, default: "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true

end
