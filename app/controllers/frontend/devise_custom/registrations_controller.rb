# overrides devise/app/controllers/devise/registrations_controller.rb

module Frontend
  module DeviseCustom

    class RegistrationsController < ::Devise::RegistrationsController

      def sign_up_params

        params.require(:user).permit(:username, :email, :password)

      end

    end 

  end
end