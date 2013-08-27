module Frontend
  class InquiriesController < ApplicationController
    
    layout 'one-column'

    def new
        @inquiry = Physical::General::Inquiry.new
    end

    def create
        @inquiry = Physical::General::Inquiry.new(inquiry_params)
        @inquiry.user = current_user if current_user
        @inquiry.submitted_from_url = request.env["HTTP_REFERER"]
        if @inquiry.save
            flash[:alert] = nil
            redirect_to inquiry_success_path
        else
            flash[:alert] = "Something went wrong. Please correct any errors and try again."
            render 'new'
        end
    end

    def success

    end

    private

    def inquiry_params
        params.require(:inquiry).permit(:first_name, :last_name, :message, :phone_number, :email)
    end

  end
end