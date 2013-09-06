module Frontend
  module Content
    class FeaturedArchitectsController < ApplicationController

      layout :resolve_layout
      before_action :get_profile, :except => [:index]
      before_action :authorize_user, :only => [:edit, :update]

      def index
        @featured_architect_profiles = Physical::User::UserProfile.includes(:user).where('is_featured_architect IS TRUE').order('featured_architect_position ASC, id DESC')
      end

      def show
        # create a featured work album if it doesn't already exist for the vendor
        @profile.create_featured_work_album(:parent => @profile, :title => "Featured Work") if @profile.featured_work_album == nil
      end

      def edit
      end

      def update
        @profile.update_attributes(profile_params)
        if @profile.save
          flash[:notice] = "Changes saved."
          redirect_to featured_architect_with_slug_path(:slug => @profile.user.slug)
        else
          flash[:alert] = "Something went wrong."
          render 'edit'
        end
      end

      private

        def authorize_user
          forbidden unless can? :update, @profile
        end

        def get_profile
          identifier = params.has_key?(:slug) ? "users.slug='#{params[:slug]}'" : "user_profiles.id=#{params[:id]}"
          # make sure they are featured 
          profiles = Physical::User::UserProfile.includes(:user).where("is_featured_architect IS TRUE AND #{identifier}").references(:user).limit(1)
          @profile = profiles.count == 0 ? nil : profiles.first
          return not_found unless @profile
        end

        def profile_params
          params.require(:profile).permit(:first_name, :middle_name, :last_name, :avatar, :bio)
        end

        def resolve_layout
          case action_name
          when 'index', 'edit'
            'columns-75-25'
          else
            'columns-25-75'
          end
        end

    end
  end
end