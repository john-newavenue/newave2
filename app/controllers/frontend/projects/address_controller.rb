module Frontend
  module Projects
    class AddressController < FrontendBaseController
      # TODO: authorization for specific project
      before_filter :test

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
        else
          flash[:alert] = "We found some errors in your submission. Please correct them."
          render 'edit'
        end
        render 'edit'
      end

      def test
        raise your
      end

      private

        def address_params
          params.require(:address).permit(Physical::General::Address::FIELDS_PARAMS)
        end
    end
  end
end