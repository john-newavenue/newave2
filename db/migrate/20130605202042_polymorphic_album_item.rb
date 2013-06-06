class PolymorphicAlbumItem < ActiveRecord::Migration
  def up
    change_table :album_items do |t|
      t.remove      :asset_id
      t.references  :asset, :polymorphic => true
    end
  end

  def down
    change_table :album_items do |t|
      t.remove      :asset_id, :asset_type
      t.integer     :asset_id
    end
  end
end
