class AddUniqueToProjectRoles < ActiveRecord::Migration
  def change
    add_index :project_roles, :name, :unique => true
  end
end
