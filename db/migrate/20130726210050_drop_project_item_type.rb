class DropProjectItemType < ActiveRecord::Migration
  def up
    remove_column :project_items, :type
  end

  def down
    add_column :project_items, :type, :integer
  end
end
