module Physical
  module Project
    class ProjectRole < ActiveRecord::Base
      validates :name, :presence => true, :uniqueness => true, :allow_blank => false

      # see db/seeds.rb for roles

      def self.role_params
        # returns [ [<Role: "Project Manager">, "project_manager"], ... ]
        self.all.map { |r| [r, r.name.parameterize.underscore] }
      end
      
    end
  end
end