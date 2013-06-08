class AlbumOrderAndCover < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.references    :cover_image
    end

    change_table :album_items do |t|
      t.integer       :position, :default => 9999, :null => false
    end
  end
end
