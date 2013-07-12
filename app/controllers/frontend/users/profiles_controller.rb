module Frontend
  module Users
    class ProfilesController < ApplicationController
      layout 'application'

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
          params.require(:profile).permit(:first_name, :middle_name, :last_name, :avatar, :bio)
        end

    end
  end
end