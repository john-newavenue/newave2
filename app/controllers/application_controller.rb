class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def get_page_param
    page = /\A([0-9]+)\z/.match(params[:page]) ? params[:page].to_i : 1
  end

  # set in Frontend::DeviseCustom::RegistrationsController
  # def after_sign_up_path_for(user)
  #   redirect_destination = user_profile_path(:username_slug => user.slug)
  #   sign_up_success_redirect_path + "?redirect=#{redirect_destination}"
  # end

  def after_sign_in_path_for(user)
    redirect_destination = user_profile_path(:username_slug => user.slug)
    sign_in_success_redirect_path + "?redirect=#{redirect_destination}"
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
