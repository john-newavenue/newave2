module Frontend
  module Users
    class PasswordsController < ApplicationController
      layout 'profile'

      before_action :authenticate_user!
      before_action :authorize_user

      # GET /user/123/password/edit
      def edit
        @password_change = Logical::Users::PasswordChange.new
      end

      # PATCH /user/123/password/
      # PUT /user/123/password/
      def update
        @password_change = Logical::Users::PasswordChange.new(password_change_params)
        @password_change.user = @user
        if @password_change.save
          flash[:notice] = "Successfully changed your password."
          current_user.reload
          sign_in(current_user, :bypass => true)
          redirect_to user_profile_path(@user.slug)
        else
          flash[:alert] = "Something went wrong. Please fix any errors."
          render 'edit'
        end
      end

      private

        def authorize_user
          user = ::User.find_by_id(params[:id])
          forbidden unless can? :update, user
          @user = user
          @profile = @user.profile
        end

        def password_change_params
          params.require(:password_change).permit(:current_password, :new_password, :new_password_confirmation)
        end



    end
  end
end