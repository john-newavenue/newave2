class RenameAdminProjectTypesToProjectTypes < ActiveRecord::Migration
  def change
    rename_table :admin_project_types, :project_types
  end
end
