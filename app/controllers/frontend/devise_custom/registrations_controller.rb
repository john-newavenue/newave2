# overrides devise/app/controllers/devise/registrations_controller.rb

module Frontend
  module DeviseCustom

    class RegistrationsController < ::Devise::RegistrationsController
      after_filter :assign_user_role, :only => :create

      def after_sign_up_path_for(resource)
        '/user/' + resource.slug
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