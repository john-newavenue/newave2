module Physical
  module Vendor
    class Vendor < ActiveRecord::Base

      # TODO  
      #  * test destroy

      #
      # validations
      #      

      validates :name, :presence => true, :allow_blank => false, :uniqueness => true
      validates :slug, :presence => true, :allow_blank => false
      validates :description, :presence => false, :allow_blank => true
      # lazy inclusion set so that set isn't defined fixed to when the class is defined
      validates :vendor_type, :allow_nil => false, :inclusion => { 
        :in => proc { Physical::Vendor::VendorType.all.to_a},
        :message => "Invalid vendor type."
      }
      
      # 
      # other
      #

      has_attached_file :logo, styles: { profile: "188x250" }

      #
      # associations
      #

      belongs_to :vendor_type, :class_name => "Physical::Vendor::VendorType"
      has_many :vendor_members, :class_name => "Physical::Vendor::VendorMember", :dependent => :destroy
      has_many :members, :through => :vendor_members, :source => :user, :class_name => "::User"
      has_many :albums, :class_name => 'Physical::Album::Album', :source => :parent, :foreign_key => "parent_id"

      acts_as_url :name, :sync_url => true, :url_attribute => :slug

      #
      # scopes
      #

      default_scope order('name ASC')
      scope :architects, where(:vendor_type => Physical::Vendor::VendorType.find_by_name('Architect'))


      #
      # methods
      #

      def add_member(user)
        if user.has_role? :vendor and not self.members.to_a.include? user
          self.members << user
        end
      end

    end
  end
end