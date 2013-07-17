class SetNullableParentOnAlbum < ActiveRecord::Migration
  
  def up
    change_column :albums, :parent_id, :integer, :null => true
    change_column :albums, :parent_type, :string, :null => true
    add_column :albums, :position, :integer, :default => 9999
  end

  def down
    change_column :albums, :parent_id, :integer, :null => false
    change_column :albums, :parent_type, :string, :null => false
    remove_column :albums, :position
  end

end
