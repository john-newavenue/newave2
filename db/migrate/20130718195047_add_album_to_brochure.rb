class AddAlbumToBrochure < ActiveRecord::Migration
  def change
    add_column :brochures, :album_id, :integer
    add_index :brochures, :album_id
  end
end
