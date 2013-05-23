class AssetsAndAlbums < ActiveRecord::Migration
  def change

    create_table :albums do |t|
      t.references  :parent, :polymorphic => true, :index => true # such as a vendor or a project
      t.string      :title
      t.text        :description
      t.timestamps
    end

    create_table :album_items do |t|
      t.integer     :album_id
      t.integer     :asset_id
      t.timestamps
    end

    add_index :album_items, :album_id
    add_index :album_items, :asset_id

    create_table :assets, :as_relation_superclass => true do |t|
      t.text      :description
      t.timestamps
    end

    create_table :image_assets do |t|
      t.timestamps
      t.attachment  :image
    end

  end

end
