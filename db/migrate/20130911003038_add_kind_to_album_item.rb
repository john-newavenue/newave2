class AddKindToAlbumItem < ActiveRecord::Migration
  def up
    add_column :album_items, :kind, :string, :null => false, :default => "picture"
    Physical::Album::AlbumItem.reset_column_information
    Physical::Album::AlbumItem.all.each do |a|
      if /^image\/(png|gif|jpeg|jpg|bmp)/.match a.attachment_content_type
        a.kind = "picture"
        a.save
      end
    end
  end

  def down
    remove_column :album_items, :kind
  end
end
