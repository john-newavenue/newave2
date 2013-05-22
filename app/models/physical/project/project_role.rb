module Physical
  module Project
    class ProjectRole < ActiveRecord::Base
      validates :name, :presence => true, :uniqueness => true, :allow_blank => false

      # see db/seeds.rb for roles

      def self.role_params
        # returns [ [<Role: "Project Manager">, "project_manager"], ... ]
        self.all.map { |r| [r, r.name.parameterize.underscore] }
      end

      def to_user_role
        # for example, Customer returns :customer and Project Manager returns :project_manager
        # see seeds.rb
        name.parameterize.underscore.to_sym

        # in the future this could expand to include the case as:
        # Lender returning :vendor or :financer or whatever
      end
      
    end
  end
end