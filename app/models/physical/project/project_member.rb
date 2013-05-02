module Physical
  module Project
    class ProjectMember < ActiveRecord::Base
      belongs_to :project_role
      belongs_to :project
      belongs_to :user

      validates :project_role_id, :presence => true, :numericality => { :only_integer => true }
      validates :project_id, :presence => true, :numericality => { :only_integer => true }
      validates :user, :presence => true

    end
  end
end