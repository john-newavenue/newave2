class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, :null => false
    add_index :users, :slug
    Physical::Album::AlbumItem.find_each(&:save)
  end
end
