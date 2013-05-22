# overrides devise/app/controllers/devise/registrations_controller.rb

module Frontend
  module DeviseCustom

    class RegistrationsController < ::Devise::RegistrationsController
      after_filter :assign_user_role, :only => :create

      def after_sign_up_path_for(resource)
        '/user/' + resource.slug
      end

      def create
        self.resource = build_resource(sign_up_params)
        if resource.save
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_up(resource_name, resource)
            respond_with resource, :location => user_profile_path(resource.slug)
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