module Physical
  module Project
    class Project < ActiveRecord::Base

      #
      # associations
      #

      belongs_to :address, :class_name => "Physical::General::Address"
      belongs_to :primary_album, :class_name => "Physical::Album::Album"
      has_many :memberships, :class_name => "Physical::Project::ProjectMember"
      has_many :members, :through => :memberships, :source => :user, :class_name => "::User"
      has_many :items, :class_name => "Physical::Project::ProjectItem", :after_add => proc { |p| p.touch }

      #
      # validations
      #

      validates :title, :presence => true, :length => { :minimum => 1 }
      validates :description, :presence => true, :allow_blank => true, :length => { :maximum => 1000 }

      #
      # behaviors
      #

      after_create :build_associated_models
      resourcify # lets rolify attach roles to this class
      accepts_nested_attributes_for :address

      #
      # scopes
      #

      default_scope order('created_at DESC')
      scope :by_recency, order('updated_at DESC')

      def items_readable_for(user)
        # project members can public and private items in a private project
        # anonymous users can see only public items of public projects
        if user and (user.has_role? :admin or self.members.include? user)
          self.items
        else
          self.private ? self.items.none : self.items.public
        end
      end

      #
      # other
      #

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
            p = Physical::Project::ProjectMember.new
            p.user = user
            p.project = self
            p.project_role = possible_project_roles[role_index-1].first
            p.save
            return true
          end
        else
          super name, *args, &block
        end
      end

      private

        def build_associated_models
          self.build_address
          self.build_primary_album(:parent => self, :title => "Project Album")
          self.save(:validate => false)
        end
    end
  end
end