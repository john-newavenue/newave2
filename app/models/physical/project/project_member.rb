module Physical
  module Project
    class ProjectMember < ActiveRecord::Base
      has_many :project_roles
      has_one :project
      has_one :user

      validates :project_role_id, :presence => true, :numericality => { :only_integer => true }
      validates :project_id, :presence => true, :numericality => { :only_integer => true }
    end
  end
end