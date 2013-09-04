class AddArchitectFeatures < ActiveRecord::Migration
  def change
    add_column :user_profiles, :is_featured_architect, :boolean
    add_column :user_profiles, :featured_architect_position, :integer, :default => 0
  end
end
