class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    Physical::Project::ProjectRole.role_params.each do |role_param|
      role = role_param[0]
      role_name = role_param[1]
      instance_variable_set("@#{role_name}_role", role)
    end

    # anyone can read or update their own profile
    if user.has_any_role?
        can :update, Physical::User::UserProfile, :id => [user.profile.id]
        can :read, Physical::User::UserProfile, :id => [user.profile.id]
    end

    # user's projects
    can :update, Physical::Project::Project, :id => user.projects.map(&:id)
    can :update, Physical::Album::Album, :id => user.projects.map(&:primary_album_id)
  

    # vendors
    if user.has_role? :vendor
        # can :update, Physical::Vendor::Vendor, :id => user.vendors.map(&:id)
        can :update, user.profile.featured_work_album
        can :create, Physical::Album::Album
    end

    # project managers
    if user.has_role? :project_manager
        can :manage, Physical::Vendor::Vendor
        can :manage, Physical::User::UserProfile
    end

    # admin
    if user.has_role? :admin
        # can :manage, Physical::Vendor::Vendor
        can :manage, :all
    end

    # service providers
    if user.has_role? :admin or user.has_role? :project_manager or user.has_role? :vendor
        can :read, Physical::User::UserProfile
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

