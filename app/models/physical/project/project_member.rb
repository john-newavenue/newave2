module Physical
  module Project
    class ProjectMember < ActiveRecord::Base
      belongs_to :project_role
      belongs_to :project
      belongs_to :user

      validates :project_role_id, :presence => true, :numericality => { :only_integer => true }
      validates :project_id, :presence => true, :numericality => { :only_integer => true }
      validates :user, :presence => true

      belongs_to :project_role, :class_name => 'Physical::Project::ProjectRole'
      belongs_to :project, :class_name => 'Physical::Project::Project'
      belongs_to :user, :class_name => 'User'

    end
  end
end