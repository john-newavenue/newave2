module Frontend
  module Crm
    class FeaturedArchitectsController < CrmBaseController

      before_action :get_profile, :only => [:edit, :update]

      def index
        vendor_user_ids = ::User.with_role(:vendor).map(&:id).join(',')
        if not vendor_user_ids.blank?
          @profiles = ::Physical::User::UserProfile.where("user_id in (#{vendor_user_ids})")
        else
          @profiles = ::Physical::User::UserProfile.where('user_id < 0')
        end
      end

      def edit
      end

      def update
        @profile.update_attributes(profile_params)
        if @profile.save
          flash[:notice] = "Changes saved."
          redirect_to crm_featured_architects_path
        else
          flash[:alert] = 'Something went wrong.'
          render 'edit'
        end
      end


      private

        def get_profile
          @profile = ::Physical::User::UserProfile.find(params[:id])
          @user = @profile.user
        end

        def profile_params
          params.require('profile').permit(:is_featured_architect, :featured_architect_position)
        end

    end
  end
end