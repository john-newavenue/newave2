module Physical
  module Vendor
    class VendorMember < ActiveRecord::Base

      validates :user, :presence => true, :inclusion => { :in => proc { User.with_role :vendor } }
      validates :vendor, :presence => true, :inclusion => { :in => proc { Physical::Vendor::Vendor.all.to_a } }

      belongs_to :vendor, :class_name => 'Physical::Vendor::Vendor'
      belongs_to :user, :class_name => 'User'

    end
  end
end