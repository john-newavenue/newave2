module Logical
  module Users
    class InvitedUser
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      attr_accessor :password, :password_confirmation, :invitation_token

      validates :password, :presence => true, :allow_blank => false, :length => { in: 6..128 }
      validates :password_confirmation, :presence => true, :allow_blank => false, :length => { in: 6..128 }

      validate :password, :matches_password_confirmation

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
      
      def persisted?
        false
      end

      def matches_password_confirmation
        if password != password_confirmation
          errors.add(:password, "must match password confirmation.")
        end
      end

    end
  end
end