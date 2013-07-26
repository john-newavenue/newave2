class AddPrivateToProjectItem < ActiveRecord::Migration
  def change
    add_column :project_items, :private, :boolean, :default => false
  end
end
