class RemoveROles < ActiveRecord::Migration
  def change
    drop_table :users_physical_user_roles
    drop_table :physical_user_roles
  end
end
