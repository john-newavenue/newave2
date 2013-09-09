class AddFieldsToAlbumItems < ActiveRecord::Migration
  def change
    add_column :album_items, :comment, :text
    add_column :album_items, :credit_name, :string
    add_column :album_items, :credit_url, :string
  end
end
