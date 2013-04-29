class AdminAbility
  include CanCan::Ability
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role?(:admin)
      can :manage, :admin
      can :manage, :project_type
    end
  end

end