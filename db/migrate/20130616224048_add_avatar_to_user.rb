class AddAvatarToUser < ActiveRecord::Migration

  def up
    add_attachment :user_profiles, :avatar
  end

  def down
    remove_attachment :user_profiles, :avatar
  end  
  
end
