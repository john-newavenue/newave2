module Physical
  module Vendor
    class VendorType < ActiveRecord::Base
      # name
      # slug
      # description

      validates :name, :presence => true, :allow_blank => false, :uniqueness => true
      validates :slug, :presence => true, :allow_blank => false
      validates :description, :presence => false, :allow_blank => true

      acts_as_url :name, :sync_url => true, :url_attribute => :slug

      # TODO: title case name before create filter
      # TODO: ordering alphabetically
    end
  end
end