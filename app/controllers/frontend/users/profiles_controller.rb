module Frontend
  module Users
    class ProfilesController < ApplicationController
      layout 'profile'

      before_filter :authenticate_user! => [:edit, :update]
      before_action :authorize_user, :only => [:edit, :update]
      
      def show
        @user = ::User.find_by_slug(params[:username_slug])

        @profile = @user.profile.decorate
        @user = @user.decorate
      end

      def edit
        @user = ::User.find_by_id(params[:id])
        @user.decorate
        @profile = @user.profile
      end

      def update
        @user = ::User.find_by_id(params[:id])
        @profile = @user.profile
        @profile.update_attributes(profile_params)
        if @profile.valid?
          @profile.save
          @user.reload
          flash[:notice] = "Successfully updated your profile information."
          redirect_to user_profile_path(@user.slug)
        else
          flash[:alert] = "There was an error."
          render 'edit'
        end

      end

      private

        def authorize_user
          user = ::User.find_by_id(params[:id])
          forbidden unless can? :update, user.profile
        end

        def profile_params
          params.require(:profile).permit(:first_name, :middle_name, :last_name, :avatar, :bio, :display_name, :user_attributes => [:username, :email, :id] )
        end

    end
  end
end