class User < ActiveRecord::Base

  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  validates :username, :presence => true, :uniqueness => true, :length => { :minimum => 3 },
            :format => { :with => /\A[A-Z0-9a-z\w\b\ \-\_\'\!&@#\.]*\z/i,
              :message => "may contain only alphanumeric characters and common special characters." }
  validates :email, :uniqueness => true, :presence => true,
            :format => { :with => Devise.email_regexp, :message => "isn't valid"}

  validates :password, :length => { :minimum => 6 }

  has_many :project_memberships, :class_name => "Physical::Project::ProjectMember"
  has_many :projects, :through => :project_memberships, :class_name => "Physical::Project::Project"
  

  #scope :projects_as_role, lambda { |user, role| Physical::Project::Project.with_role(role, user) }

  # TODO: can probably be optimized with an advanced SQL query
  # def get_projects()
  #   Physical::Project::Project.with_role
  # end
          
end