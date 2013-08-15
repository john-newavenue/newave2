class AddUserToProjectItem < ActiveRecord::Migration
  def up
    add_column :project_items, :user_id, :integer
    add_foreign_key :project_items, :users, :column => 'user_id'

    Physical::Project::ProjectItem.all.each do |project_item|
      project_item.user = project_item.project.members.first
      project_item.save
    end
  end

  def down
    remove_foreign_key :project_items, :users
    remove_column :project_items, :user_id
  end
end
