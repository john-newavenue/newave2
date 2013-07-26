module Frontend
  module Users

    class AuthenticationsController < ApplicationController
      def facebook
        omni = request.env["omniauth.auth"]
        authentication = Authentication.find_by(:provider => omni['provider'], :uid => omni['uid'])
        # a person who is already authenticated before
        if authentication
          flash[:notice] = "Logged in Successfully"
          sign_in_and_redirect User.find(authentication.user_id)
        
        # there exists a user, who has not authenticated his/her twitter account yet.
        elsif current_user
         token = omni['credentials'].token
         token_secret = omni['credentials'].secret
         current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
         flash[:notice] = "Authentication successful."
         sign_in_and_redirect current_user
        
        # a person who is going to register to our website by authenticating with Facebook
        else
          user = User.new
          user.apply_omniauth(omni)
          user.email = omni['extra']['raw_info'].email
          user.password = Devise.friendly_token[0,20]
          # in case of collisions, append characters until username is one that hasn't beent taken
          user.username = omni['extra']['raw_info']['username']
          until User.find_by(:username => user.username) == nil
            user.username = user.username + Devise.friendly_token[0,1]
          end
          user.slug = user.username.parameterize
          if user.save
            flash[:notice] = "Welcome."
            sign_in_and_redirect User.find(user.id)
          else
            session[:omniauth] = omni.except('extra')
            redirect_to new_user_registration_path
          end
        end

      end
    end
  end
end