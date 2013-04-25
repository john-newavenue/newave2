class Admin::BaseController < ApplicationController
  layout 'admin'
  authorize_resource :class => false # (CanCan setting) no associated manageable resource

  def index
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end
end