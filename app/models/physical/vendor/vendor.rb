module Physical
  module Vendor
    class Vendor < ActiveRecord::Base
      # name
      # slug
      # descriptoin
      # url
      # vendor_type_id

      belongs_to :vendor_type, :class_name => "Physical::Vendor::VendorType"

      validates :name, :presence => true, :allow_blank => false, :uniqueness => true
      validates :slug, :presence => true, :allow_blank => false
      validates :description, :presence => false, :allow_blank => true
      # lazy inclusion set so that set isn't defined fixed to when the class is defined
      validates :vendor_type, :allow_nil => false, :inclusion => { :in => proc { Physical::Vendor::VendorType.all.to_a} }

      # TODO  test destroy
      has_many :members, :class_name => "Physical::Vendor::VendorMember", :dependent => :destroy

      acts_as_url :name, :sync_url => true, :url_attribute => :slug

    end
  end
end