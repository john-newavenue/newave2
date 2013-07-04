class ProjectItems < ActiveRecord::Migration

  def up
    create_table :project_items do |t|
      t.references :project, :index => true
      t.text       :body
      t.integer    :type
      t.datetime   :deleted_at
      t.timestamps
    end

    add_foreign_key :project_items, :projects, :dependent => :delete, :column => 'project_id'

    create_table :project_item_assets do |t|
      t.references    :project_item, :index => true
      t.references    :album_item
      t.timestamps
    end

    add_foreign_key :project_item_assets, :project_items, :dependent => :delete, :column => 'project_item_id'
    add_foreign_key :project_item_assets, :album_items, :column => 'album_item_id'

  end

  def down

    remove_foreign_key :project_item_assets, :project_items
    remove_foreign_key :project_item_assets, :album_items
    drop_table :project_item_assets

    remove_foreign_key :project_items, :projects
    drop_table :project_items

  end
  
end
