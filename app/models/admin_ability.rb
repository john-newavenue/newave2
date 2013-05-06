class AdminAbility
  include CanCan::Ability
  def initialize(user)

    user ||= User.new

    can :access, ::Frontend::Admin::AdminBaseController

  end
end