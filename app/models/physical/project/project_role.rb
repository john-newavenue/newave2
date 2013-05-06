module Physical
  module Project
    class ProjectRole < ActiveRecord::Base
      validates :name, :presence => true, :uniqueness => true, :allow_blank => false

      CLIENT = ProjectRole.find_by_name('Client')
      PROJECT_MANAGER = ProjectRole.find_by_name('Project Manager')
      ARCHITECT = ProjectRole.find_by_name('Architect')
      BUILDER = ProjectRole.find_by_name('Builder')
    end
  end
end