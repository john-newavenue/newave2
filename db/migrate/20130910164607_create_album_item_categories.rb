class CreateAlbumItemCategories < ActiveRecord::Migration
  def up
    create_table :album_item_categories do |t|
      t.string      :name, :null => false
      t.integer     :parent_id, :null => true
      t.timestamps
      t.integer     :position, :null=> true, :default => 0
    end
    add_foreign_key :album_item_categories, :album_item_categories, :column => 'parent_id'

    add_column :album_items, :category_id, :integer, :null => true
    add_foreign_key :album_items, :album_item_categories, :column => 'category_id'
  end

  def down
    remove_foreign_key :album_items, :name => 'album_items_category_id_fk'
    remove_column :album_items, :category_id
    remove_foreign_key :album_item_categories, :name => 'album_item_categories_parent_id_fk'
    drop_table :album_item_categories
  end
end
