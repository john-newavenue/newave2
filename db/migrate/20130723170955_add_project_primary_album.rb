class AddProjectPrimaryAlbum < ActiveRecord::Migration
  def up
    add_column :projects, :primary_album_id, :integer, :null => true
    add_foreign_key :projects, :albums, :column => 'primary_album_id'
  end

  def down
    remove_foreign_key :projects, 'primary_album'
    remove_column :projects, :primary_album_id
  end
end
