module Logical
  module Vendor
    class AddedVendorMember < Logical::TablelessBase

      attr_accessor :username, :vendor_id

      validates :username, :presence => true, :allow_blank => false
      validate :username, :username_exists

      validates :vendor_id, :presence => true, :allow_blank => false
      validate :vendor_id, :vendor_exists

      def save
        if self.valid?
          vendor = Physical::Vendor::Vendor.find_by_id(vendor_id)
          user = User.find_by_username(username) 
          vendor.add_member(user)
        else
          raise "Invalid data for #{self}"
        end
      end
      
      private

        def username_exists
          user = User.find_by_username(username) 
          vendor = Physical::Vendor::Vendor.find_by_id(vendor_id)
          if user == nil
            errors.add(:username, "User doesn't exist.")
          elsif !user.has_role? :vendor
            errors.add(:username, "User does not have a vendor account.")
          elsif user.vendors.include? vendor
            errors.add(:username, "User is already associated with #{vendor.name}.")
          elsif Physical::Vendor::VendorMember.find_by_user_id(user.id)
            errors.add(:username, "User is already associated with a vendor.")
          end
        end

        def vendor_exists
          errors.add(:vendor_id, "Vendor doesn't exist.") if Physical::Vendor::Vendor.find_by_id(vendor_id).nil?
        end

    end
  end
end