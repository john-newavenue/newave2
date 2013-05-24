module Physical
  module Project
    class Project < ActiveRecord::Base

      resourcify # lets rolify attach roles to this class

      validates :title, :presence => true, :length => { :minimum => 1 }
      validates :description, :presence => true, :allow_blank => false, :length => { :maximum => 1000 }

      belongs_to :address, :class_name => "Physical::General::Address"

      has_many :memberships, :class_name => "Physical::Project::ProjectMember"
      has_many :members, :through => :memberships, :source => :user, :class_name => "::User"

      after_create :build_associated_models

      accepts_nested_attributes_for :address

      def method_missing name, *args, &block

        name = name.to_s.downcase

        # def add_user_as_PROJECTROLE(user_instance)
        add_user_as_match = /^add_user_as_([a-z]+)$/.match name
        if add_user_as_match
          user = args.first
          possible_project_roles = Physical::Project::ProjectRole.role_params
          possible_project_role_names = possible_project_roles.map(&:last)
          desired_role_name = add_user_as_match.to_a.last.downcase
          role_index = possible_project_role_names.find_index(desired_role_name)
          # PROJECTROLE is a valid choice and user is not already a member
          if role_index != nil and not self.members.include? user
            Physical::Project::ProjectMember.create!(
              :user => user, 
              :project => self,
              :project_role => possible_project_roles[role_index-1].first
            )
            return true
          end
        end

        super
      end

      private

        def build_associated_models
          self.build_address
          self.save(:validate => false)
        end
    end
  end
end