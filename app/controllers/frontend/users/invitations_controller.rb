module Frontend
  module Users
    class InvitationsController < Devise::InvitationsController

      def update
        resource_check = Logical::Users::InvitedUser.new(update_resource_params)
        if resource_check.valid?
          self.resource = resource_class.accept_invitation!(update_resource_params)
          if resource.errors.empty?
            flash_message = resource.active_for_authentication? ? :updated : :updated_not_active                                                                                        
            set_flash_message :notice, flash_message
            sign_in(resource_name, resource)
            respond_with resource, :location => after_accept_path_for(resource)
          else
            respond_with_navigational(resource){ render :edit }
          end
        else
          # debugger
          # respond_with_navigational(resource){ render :edit }
          # resource 
          @resource = resource_check
          render 'edit'
        end
      end
    end
  end
end