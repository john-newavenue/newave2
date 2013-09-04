class DenormalizeAssets < ActiveRecord::Migration
  def up

    add_attachment :album_items, :attachment
    add_column :album_items, :attachment_type, :string
    add_column :album_items, :legacy_asset_id, :integer

    Physical::Album::AlbumItem.reset_column_information
    
    Physical::Album::AlbumItem.with_deleted.each do |album_item|
      puts "Processing #{album_item.id}"
      asset = album_item.asset
      if asset
        album_item.attachment_file_name = asset.image_file_name
        album_item.attachment_content_type = asset.image_content_type
        album_item.attachment_file_size = asset.image_file_size
        album_item.attachment_updated_at = asset.image_updated_at
        album_item.attachment_type = "image" if /^image\/(png|gif|jpeg|jpg|bmp)/.match asset.image_content_type
        album_item.legacy_asset_id = asset.id
        album_item.save
      end
    end

    # remove_column :album_items, :asset
    # drop_table :assets
    # drop_table :image_assets

    # create_table "album_items", force: true do |t|
    #   t.integer  "album_id"
    #   t.datetime "created_at"
    #   t.datetime "updated_at"
    #   t.string   "title"
    #   t.text     "description"
    #   t.datetime "deleted_at"
    #   t.integer  "asset_id"
    #   t.string   "asset_type"
    #   t.integer  "position",    default: 9999, null: false
    #   t.integer  "parent_id"
    #   t.integer  "root_id"
    # end

    # create_table "assets", force: true do |t|
    #   t.integer  "azzet_id",                             null: false
    #   t.string   "azzet_type",                           null: false
    #   t.datetime "created_at"
    #   t.datetime "updated_at"
    #   t.boolean  "soft_delete",          default: false
    #   t.integer  "origin_album_item_id"
    # end

    # create_table "image_assets", force: true do |t|
    #   t.datetime "created_at"
    #   t.datetime "updated_at"
    #   t.string   "image_file_name"
    #   t.string   "image_content_type"
    #   t.integer  "image_file_size"
    #   t.datetime "image_updated_at"
    # end

  end

  def down
    remove_attachment :album_items, :attachment
    remove_column :album_items, :attachment_type
  end

end
