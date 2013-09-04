class User < ActiveRecord::Base

  #
  # fields and associations
  #

  has_many :project_memberships, :class_name => "Physical::Project::ProjectMember"
  has_many :projects, :through => :project_memberships, :class_name => "Physical::Project::Project", :order => "projects.updated_at DESC"
  belongs_to :address, :class_name => "Physical::General::Address"
  has_many :vendor_memberships, :class_name => "Physical::Vendor::VendorMember", :dependent => :destroy
  has_many :vendors, :through => :vendor_memberships
  has_one :profile, :class_name => "Physical::User::UserProfile"
  has_many :authentications
  accepts_nested_attributes_for :profile

  #
  # validations
  #

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :length => { :minimum => 3 },
            :format => { :with => /\A[A-Z0-9a-z\w\b\ \-\_\'\!&@#\.]+\z/i,
              :message => "may contain only alphanumeric characters and common special characters." }
  validates :email, :uniqueness => {:case_sensitive => false}, :presence => true, 
            :format => { :with => Devise.email_regexp, :message => "isn't valid"}
  validates :password, length: { in: 6..128 }, on: :create
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true
  validates :slug, :presence => true, :allow_blank => false

  #
  # other
  #

  rolify
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :invitable, :omniauthable

  #
  # callbacks
  #

  after_create :build_associated_models
  acts_as_url :username, :sync_url => true, :url_attribute => :slug


  #
  # scope
  #

  scope :invited, lambda { where("users.invitation_token IS NOT NULL") }
  scope :not_invited, lambda { where("users.invitation_token IS NULL") }
  scope :active, lambda { where("users.invitation_token IS NULL OR users.invitation_accepted_at IS NOT NULL")}
  default_scope { order('users.created_at DESC') }

  #
  # methods
  #

  def apply_omniauth(omni)
    authentications.build(
      :provider => omni['provider'],
      :uid => omni['uid'],
      :token => omni['credentials'].token,
      :token_secret => omni['credentials'].secret)
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  private

    def build_associated_models
      self.build_profile
      self.save(:validate => false)
    end

end