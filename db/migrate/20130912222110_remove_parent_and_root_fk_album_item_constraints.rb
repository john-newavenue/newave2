class RemoveParentAndRootFkAlbumItemConstraints < ActiveRecord::Migration
  def up
    remove_foreign_key :album_items, :parent
    remove_foreign_key :album_items, :root
    remove_foreign_key :project_item_assets, :album_items
  end

  def down
    add_foreign_key :album_items, :album_items, :column => 'parent_id'
    add_foreign_key :album_items, :album_items, :column => 'root_id'
    add_foreign_key :project_item_assets, :album_items
  end
end
