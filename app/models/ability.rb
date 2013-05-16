class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    Physical::Project::ProjectRole.role_params.each do |role_param|
      role = role_param[0]
      role_name = role_param[1]
      instance_variable_set("@#{role_name}_role", role)
    end

    # projects user is a client of
    client_projects = Physical::Project::ProjectMember.where(
        :user => user,
        :project_role => @client_role
        ).map { |m| m.project.id } 
    can :update, Physical::Project::Project, :id => client_projects

    # vendors
    if user.has_role? :vendor
        vendor_membership = Physical::Vendor::Vendormember.where(:user => user).map { |v| v.id }
        can :update, Physical::Vendor::Vendor, :id => vendor_membership
    end

    # admin
    if user.has_any_role? :admin, :project_manager
        can :access, Physical::Vendor::Vendor
    end
    

    # if user.has_role?(:admin)
    #     #can :manage, [:admin, ap]

    #     # can :access, Frontend::Admin::AdminController
    #     # can :access, ["admin/users"]

    #     # TODO: restrict UsersController access
    #     #debugger
    #     can :access, ::Frontend::Admin::AdminBaseController
    #     # can :manage, ::Frontend::Admin::AdminBaseController
    #     # can :read, ::Frontend::Admin::AdminBaseController
    #     # can :access, ::Frontend::Admin::AdminController
    #     # can :access, ::Frontend::Admin::UsersController
    # else
    #     # cannot :access, Frontend::Admin::AdminController
    # end

    # if user.has_role?(:admin)
    #     #can :manage, [:admin, ap]
        
    #     can :access, ["admin/users"]
    #     # can :access, Frontend::Admin::UsersController
    #     # can :access, :all
    # end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
