class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def after_sign_in_path_for(resource_or_scope)
    user = resource_or_scope
    if user.has_role? :admin
      crm_path
    else
      user_profile_path(:username_slug => resource_or_scope.slug)
    end
  end

  def not_found
    render :file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => 'one-column'
    return
  end

  def forbidden
    render :file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => 'one-column'
    return
  end

  protected

end
