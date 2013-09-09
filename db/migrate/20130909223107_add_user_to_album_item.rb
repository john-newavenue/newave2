class AddUserToAlbumItem < ActiveRecord::Migration
  def up
    add_column :album_items, :user_id, :integer
    add_foreign_key :album_items, :users, :column => 'user_id'
  end

  def down
    remove_foreign_key :album_items, :user
    remove_column :album_items, :user_id
  end
end
