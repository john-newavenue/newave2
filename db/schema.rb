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

ActiveRecord::Schema.define(version: 20130911003038) do

  create_table "addresses", force: true do |t|
    t.string "line_1"
    t.string "line_2"
    t.string "city"
    t.string "state"
    t.string "zip_or_postal_code"
    t.string "country"
    t.string "other_details"
  end

  create_table "album_item_categories", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   default: 0
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
    t.integer  "position",                default: 9999,      null: false
    t.integer  "parent_id"
    t.integer  "root_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "attachment_type"
    t.integer  "legacy_asset_id"
    t.text     "comment"
    t.string   "credit_name"
    t.string   "ciredit_url"
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "kind",                    default: "picture", null: false
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
    t.integer  "cover_image_id"
    t.integer  "position",       default: 9999
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

  create_table "authentications", force: true do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "brochures", force: true do |t|
    t.string   "title",                                                            null: false
    t.integer  "position",                                         default: 9999
    t.string   "category",                                                         null: false
    t.text     "short_description"
    t.text     "long_description"
    t.decimal  "area",                     precision: 7, scale: 2
    t.decimal  "number_of_bath",           precision: 2, scale: 1
    t.decimal  "number_of_bed",            precision: 2, scale: 1
    t.boolean  "has_loft",                                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "album_id"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "slug"
    t.boolean  "is_published",                                     default: true,  null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.text     "ideal_for"
  end

  add_index "brochures", ["album_id"], name: "index_brochures_on_album_id", using: :btree

  create_table "image_assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "inquiries", force: true do |t|
    t.string   "category",           default: "contact_form", null: false
    t.text     "submitted_from_url",                          null: false
    t.integer  "user_id"
    t.string   "first_name",                                  null: false
    t.string   "last_name",                                   null: false
    t.string   "phone_number"
    t.string   "email",                                       null: false
    t.text     "message",                                     null: false
    t.string   "referral"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interested_in"
    t.string   "location"
  end

  create_table "project_item_assets", force: true do |t|
    t.integer  "project_item_id"
    t.integer  "album_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_item_assets", ["project_item_id"], name: "index_project_item_assets_on_project_item_id", using: :btree

  create_table "project_items", force: true do |t|
    t.integer  "project_id"
    t.text     "body"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",    default: false
    t.integer  "user_id"
    t.string   "category",   default: "text", null: false
    t.boolean  "has_assets", default: false,  null: false
  end

  add_index "project_items", ["project_id"], name: "index_project_items_on_project_id", using: :btree

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
    t.string   "title",                            null: false
    t.string   "description",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
    t.datetime "deleted_at"
    t.boolean  "private",          default: false, null: false
    t.integer  "primary_album_id"
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

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "website_title"
    t.string   "website_url"
    t.integer  "address_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_featured_architect"
    t.integer  "featured_architect_position", default: 0
    t.integer  "featured_work_album_id"
  end

  add_index "user_profiles", ["featured_work_album_id"], name: "index_user_profiles_on_featured_work_album_id", using: :btree
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
    t.datetime "deleted_at"
  end

  add_index "vendors", ["name"], name: "index_vendors_on_name", unique: true, using: :btree
  add_index "vendors", ["slug"], name: "index_vendors_on_slug", unique: true, using: :btree

  add_foreign_key "album_item_categories", "album_item_categories", :name => "album_item_categories_parent_id_fk", :column => "parent_id"

  add_foreign_key "album_items", "album_item_categories", :name => "album_items_category_id_fk", :column => "category_id"
  add_foreign_key "album_items", "album_items", :name => "album_items_parent_id_fk", :column => "parent_id"
  add_foreign_key "album_items", "album_items", :name => "album_items_root_id_fk", :column => "root_id"
  add_foreign_key "album_items", "users", :name => "album_items_user_id_fk"

  add_foreign_key "assets", "album_items", :name => "assets_origin_album_item_id_fk", :column => "origin_album_item_id"

  add_foreign_key "inquiries", "users", :name => "inquiries_user_id_fk"

  add_foreign_key "project_item_assets", "album_items", :name => "project_item_assets_album_item_id_fk"
  add_foreign_key "project_item_assets", "project_items", :name => "project_item_assets_project_item_id_fk", :dependent => :delete

  add_foreign_key "project_items", "projects", :name => "project_items_project_id_fk", :dependent => :delete
  add_foreign_key "project_items", "users", :name => "project_items_user_id_fk"

  add_foreign_key "projects", "albums", :name => "projects_primary_album_id_fk", :column => "primary_album_id"

  add_foreign_key "user_profiles", "addresses", :name => "user_profiles_address_id_fk", :dependent => :delete
  add_foreign_key "user_profiles", "albums", :name => "user_profiles_featured_work_album_id_fk", :column => "featured_work_album_id"

end
