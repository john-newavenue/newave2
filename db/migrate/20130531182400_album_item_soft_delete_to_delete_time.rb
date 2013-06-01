class AlbumItemSoftDeleteToDeleteTime < ActiveRecord::Migration

  def up
    change_table :album_items do |t|
      t.remove        :soft_delete
      t.datetime      :deleted_at
    end

    add_column :albums, :deleted_at, :datetime
  end

  def down
    change_table :album_items do |t|
      t.remove     :deleted_at
      t.boolean    :soft_delete, :default => false
    end

    remove_column :albums, :deleted_at, :datetime
  end

end
