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

  attr_writer :password_confirmation
  validate :password_confirmation_matches

  #
  # other
  #

  rolify :after_add => :build_associated_role_models
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :invitable, :omniauthable

  #
  # callbacks
  #

  after_create :create_joined_timeline_event
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

  def password_confirmation_matches
    if password_confirmation 
      if password_confirmation == "" or password == ""
        errors.add(:password, "Fill out both fields to reset your password.")
      elsif (password_confirmation != "" and password != "") and password_confirmation != password
        errors.add(:password, "Password and Password Confirmation must match.")
      end
    end
  end

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

    def build_associated_role_models(role)
      if self.has_role? :vendor and profile.featured_work_album == nil
        profile.build_featured_work_album(:parent => profile, :title => "Featured Work") 
        profile.save
      end
    end

    def create_joined_timeline_event
      # if the user was invited, don't create the timeline event
      if invitation_token.nil? and Physical::Project::ProjectItem.where(:category => "joined", :user => self).count == 0
        Physical::Project::ProjectItem.create(
          :category => "joined",
          :user => self,
          :created_at => created_at,
          :updated_at => updated_at
        )
      end
    end

end