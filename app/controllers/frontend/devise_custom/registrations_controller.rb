# overrides devise/app/controllers/devise/registrations_controller.rb

module Frontend
  module DeviseCustom

    class RegistrationsController < ::Devise::RegistrationsController

      def sign_up_params

        params.require(:user).permit(:username, :email, :password)

      end

      def after_sign_up_path_for(resource)
        '/user/' + resource.slug
      end

    end 

  end
end