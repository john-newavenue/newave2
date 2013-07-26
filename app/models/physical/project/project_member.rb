module Physical
  module Project
    class ProjectMember < ActiveRecord::Base

      # TODO: add inclusion constraints
      validates :project_role_id, :presence => true#, :numericality => { :only_integer => true }
      validates :project_id, :presence => true#, :numericality => { :only_integer => true }
      validates :user, :presence => true

      belongs_to :project_role, :class_name => 'Physical::Project::ProjectRole'
      belongs_to :project, :class_name => 'Physical::Project::Project'
      belongs_to :user, :class_name => 'User'

      def <<(user)
        raise "Method Disabled. Please use project.add_user_as_[role]"
      end

    end
  end
end