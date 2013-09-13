class CreateLegacyImageColumns < ActiveRecord::Migration
  def change
    add_column :album_items, :legacy_original_image_url, :string
    add_column :album_items, :legacy_thumbnail_span3_url, :string
    add_column :album_items, :legacy_display_image_url, :string
    add_column :album_items, :legacy_display_image2_url, :string
  end
end
