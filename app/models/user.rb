class User < ActiveRecord::Base

  rolify

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :invitable

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :length => { :minimum => 3 },
            :format => { :with => /\A[A-Z0-9a-z\w\b\ \-\_\'\!&@#\.]+\z/i,
              :message => "may contain only alphanumeric characters and common special characters." }
  validates :email, :uniqueness => {:case_sensitive => false}, :presence => true, 
            :format => { :with => Devise.email_regexp, :message => "isn't valid"}

  validates :password, length: { in: 6..128 }, on: :create
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  validates :slug, :presence => true, :allow_blank => false

  has_many :project_memberships, :class_name => "Physical::Project::ProjectMember"
  has_many :projects, :through => :project_memberships, :class_name => "Physical::Project::Project"
  
  belongs_to :address, :class_name => "Physical::General::Address"

  acts_as_url :username, :sync_url => true, :url_attribute => :slug

  has_many :vendor_memberships, :class_name => "Physical::Vendor::VendorMember", :dependent => :destroy
  has_many :vendors, :through => :vendor_memberships

  has_one :profile, :class_name => "Physical::User::UserProfile"

  after_create :build_associated_models

  private

    def build_associated_models
      self.build_profile
      self.save(:validate => false)
    end

end