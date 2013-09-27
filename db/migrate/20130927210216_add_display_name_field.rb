class AddDisplayNameField < ActiveRecord::Migration
  def change
    add_column :user_profiles, :display_name, :string
  end
end
