module Frontend
  module Projects
    class AddressController < FrontendBaseController
      # TODO: authorization for specific project
      before_filter :authenticate_user!
      before_action :authorize_user

      layout 'project'

      def edit
        @project = Physical::Project::Project.find_by_id(params[:project_id])
        @address = @project.address
      end

      def update
        @project = Physical::Project::Project.find_by_id(params[:project_id])
        if @project.address.update(address_params)
          flash[:notice] = "Address was updated successfully."
          @address = @project.address
          redirect_to project_path(@project)
          return
        else
          flash[:alert] = "We found some errors in your submission. Please correct them."
          render 'edit'
        end
      end

      private

        def address_params
          params.require(:address).permit(Physical::General::Address::FIELDS_PARAMS)
        end

        def authorize_user
          @project = Physical::Project::Project.find_by_id(params[:project_id])
          redirect_to(root_path) unless can? :update, @project

        end

    end
  end
end