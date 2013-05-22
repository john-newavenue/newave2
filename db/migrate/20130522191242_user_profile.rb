class UserProfile < ActiveRecord::Migration
  def change
    create_table(:user_profiles) do |t|
      t.integer :user_id
      t.string  :first_name
      t.string  :middle_name
      t.string  :last_name
      
    end

    add_index :user_profiles, :user_id, :unique => true
  end
end
