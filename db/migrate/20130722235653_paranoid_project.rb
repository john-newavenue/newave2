class ParanoidProject < ActiveRecord::Migration
  def change
    add_column :projects, :deleted_at, :datetime
    add_column :projects, :private, :boolean, :null => false, :default => false
  end
end
