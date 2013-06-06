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

ActiveRecord::Schema.define(version: 20130605202042) do

  create_table "addresses", force: true do |t|
    t.string "line_1"
    t.string "line_2"
    t.string "city"
    t.string "state"
    t.string "zip_or_postal_code"
    t.string "country"
    t.string "other_details"
  end

  create_table "album_items", force: true do |t|
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.datetime "deleted_at"
    t.integer  "asset_id"
    t.string   "asset_type"
  end

  add_index "album_items", ["album_id"], name: "index_album_items_on_album_id", using: :btree

  create_table "albums", force: true do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "albums", ["parent_id", "parent_type"], name: "index_albums_on_parent_id_and_parent_type", using: :btree

  create_table "assets", force: true do |t|
    t.integer  "azzet_id",                             null: false
    t.string   "azzet_type",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "soft_delete",          default: false
    t.integer  "origin_album_item_id"
  end

  add_index "assets", ["azzet_id", "azzet_type"], name: "index_assets_on_azzet_id_and_azzet_type", using: :btree

  create_table "image_assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "project_members", force: true do |t|
    t.integer  "project_role_id", null: false
    t.integer  "project_id",      null: false
    t.integer  "user_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_roles", force: true do |t|
    t.string "name", null: false
  end

  add_index "project_roles", ["name"], name: "index_project_roles_on_name", unique: true, using: :btree

  create_table "project_types", force: true do |t|
    t.string   "title",       null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_types", ["title"], name: "index_project_types_on_title", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "title",                    null: false
    t.string   "description", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
  end

  add_index "projects", ["title"], name: "index_projects_on_title", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "user_profiles", force: true do |t|
    t.integer "user_id"
    t.string  "first_name"
    t.string  "middle_name"
    t.string  "last_name"
    t.text    "bio"
    t.string  "website_title"
    t.string  "website_url"
    t.integer "address_id"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "slug"
    t.string   "invitation_token",       limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "vendor_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendor_members", ["user_id"], name: "index_vendor_members_on_user_id", using: :btree

  create_table "vendor_types", force: true do |t|
    t.string "name"
    t.string "slug"
    t.text   "description"
  end

  add_index "vendor_types", ["name"], name: "index_vendor_types_on_name", unique: true, using: :btree
  add_index "vendor_types", ["slug"], name: "index_vendor_types_on_slug", unique: true, using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "url"
    t.integer  "vendor_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "vendors", ["name"], name: "index_vendors_on_name", unique: true, using: :btree
  add_index "vendors", ["slug"], name: "index_vendors_on_slug", unique: true, using: :btree

  add_foreign_key "assets", "album_items", :name => "assets_origin_album_item_id_fk", :column => "origin_album_item_id"

  add_foreign_key "user_profiles", "addresses", :name => "user_profiles_address_id_fk", :dependent => :delete

end
