module Logical
  module Users
    class PasswordChange
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      attr_accessor :current_password, :new_password, :new_password_confirmation, :user

      validates :current_password, :presence => true, :allow_blank => false
      validate :current_password, :correct_current_password

      validates :new_password, :presence => true, :allow_blank => false, :length => { in: 6..128 }
      validates :new_password_confirmation, :presence => true, :allow_blank => false, :length => { in: 6..128 }
      validate :new_password, :matches_new_password_confirmation

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
      
      def persisted?
        false
      end

      def save
        if valid?
          user.update_attributes(:password => new_password)
          user.save
          return true
        end
        return false
      end

      private

      def correct_current_password
        if not user.valid_password?(current_password)
          errors.add(:current_password, "incorrect current password.")
        end
      end

      def matches_new_password_confirmation
        if new_password != new_password_confirmation
          errors.add(:new_password, "must match password confirmation.")
        end
      end


    end
  end
end