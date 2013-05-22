module Physical
  module User
    class UserProfile < ActiveRecord::Base
      # user
      # first name
      # middle name
      # last name

      belongs_to :user

    
    end
  end
end