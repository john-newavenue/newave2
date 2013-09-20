# overrides devise/app/controllers/devise/registrations_controller.rb

module Frontend
  module DeviseCustom

    class RegistrationsController < ::Devise::RegistrationsController
      after_filter :assign_user_role, :only => :create

      def create
        self.resource = build_resource(sign_up_params)
        if resource.save
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_up(resource_name, resource)
            redirect_destination = user_profile_path(:username_slug => resource.slug)
            respond_with resource, :location => sign_up_success_redirect_path + "?redirect=#{redirect_destination}"
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
            expire_session_data_after_sign_in!
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          @resource = resource
          respond_with @resource
        end
        session[:omniauth] = nil unless @user.new_record?

      end


      def build_resource(*args)
        super
        if !session[:omniauth].nil?
          @user.apply_omniauth(session[:omniauth])
          @user.username = session[:omniauth][:info][:nickname]
          @user.email = session[:omniauth][:info][:email]
          @user.valid?
        end
        self.resource
      end

      private


        def assign_user_role
          # if current_user is nil, there was an error in registration
          if current_user 
            # TODO: handle registration of other roles (vendor, staff)
            current_user.add_role :customer
          end
        end

        def sign_up_params
          params.require(:user).permit(:username, :email, :password)
        end



    end 

  end
end