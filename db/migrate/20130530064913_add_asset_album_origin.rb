class AddAssetAlbumOrigin < ActiveRecord::Migration
  
  def up

    change_table :assets do |t|
      t.remove :title, :description
      t.boolean         :soft_delete, :default => false
    end

    add_foreign_key :assets, :album_items, :column => 'origin_album_item_id'
    change_column :assets, :azzet_id, :integer, :null => false
    change_column :assets, :azzet_type, :string, :null => false

    change_table :album_items do |t|
      t.string          :title
      t.text            :description
      t.boolean         :soft_delete, :default => false
    end

  end

  def down

    change_table :assets do |t|
      t.remove :soft_delete
      t.string          :title
      t.string          :description
    end

    remove_foreign_key :assets, :column => 'origin_album_item_id'
    change_column :assets, :azzet_id, :integer, :null => true
    change_column :assets, :azzet_type, :string, :null => true

    change_table :album_items do |t|
      t.remove :title, :description, :soft_delete
    end

  end
end
