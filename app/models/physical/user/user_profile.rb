module Physical
  module User
    class UserProfile < ActiveRecord::Base
      
      belongs_to :user
      belongs_to :address, :class_name => "Physical::General::Address"

    
    end
  end
end