module Physical
  module Project
    class Project < ActiveRecord::Base

      resourcify # lets rolify attach roles to this class

      validates :title, :presence => true, :length => { :minimum => 1 }
      validates :description, :presence => true, :allow_blank => false, :length => { :maximum => 1000 }

      belongs_to :address, :class_name => "Physical::General::Address"

      has_many :members, :class_name => "Physical::Project::ProjectMember"

      Physical::Project::ProjectRole.role_params.each do |role_param|
        role = role_param[0]
        role_name = role_param[1]
        method_name = ("add_user_as_" + role_name.to_s).to_sym
        send :define_method, method_name do |user|
          Physical::Project::ProjectMember.create!(
            :user => user, 
            :project => self,
            :project_role => role
          )
        end
      end
    end
  end
end