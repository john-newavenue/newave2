class AddProjectItemType < ActiveRecord::Migration
  def up
    add_column :project_items, :category, :string, :null => false, :default => "text"
    add_column :project_items, :has_assets, :boolean, :null => false, :default => false
    Physical::Project::ProjectItem.reset_column_information
    Physical::Project::ProjectItem.all.each do |project_item|
      assets = project_item.project_item_assets
      if assets.count > 0
        project_item.has_assets = true
        if assets.count == 1 and assets.first.album_item and assets.first.album_item.asset_type == "Physical::Asset::ImageAsset"
          if assets.first.album_item.root != nil
            project_item.category = "clipped_picture"
          else
            project_item.category = "uploaded_picture"
          end
        elsif assets.count == 1 and assets.first.album_item and assets.first.album_item.asset_type == nil
          ai = assets.first.album_item
          if ai.root
            ai.asset = ai.root.asset
            ai.save
            project_item.category = "clipped_picture"
          end
        end
        project_item.save
        puts "Updated #{project_item.id}"
      end
    end
  end
  def down
    remove_column :project_items, :category
    remove_column :project_items, :has_assets
  end
end
