class User < ActiveRecord::Base

  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true, :allow_blank => false, :length => { :minimum => 1 , :maximum => 100},
            :format => { :with => /\A[A-Z0-9a-z\w\b\ \-\_\'\!&@#\.]+\z/i,
              :message => "A valid username may contain only alphanumeric characters and common special characters." }
  validates :email, :presence => true, :allow_blank => false,
            :format => { :with => Devise.email_regexp, :message => "Please enter a valid email address."}

  has_many :project_memberships, :class_name => "Physical::Project::ProjectMember"
  has_many :projects, :through => :project_memberships, :class_name => "Physical::Project::Project"
  

  #scope :projects_as_role, lambda { |user, role| Physical::Project::Project.with_role(role, user) }

  # TODO: can probably be optimized with an advanced SQL query
  # def get_projects()
  #   Physical::Project::Project.with_role
  # end
          
end