class AddAncestryToAlbumItem < ActiveRecord::Migration
  def up
    add_column :album_items, :parent_id, :integer
    add_column :album_items, :root_id, :integer
    add_foreign_key :album_items, :album_items, :column => 'parent_id'
    add_foreign_key :album_items, :album_items, :column => 'root_id'
  end

  def down
    remove_foreign_key :album_items, :parent
    remove_foreign_key :album_items, :root
    remove_column :album_items, :parent_id
    remove_column :album_items, :root_id
  end
end
