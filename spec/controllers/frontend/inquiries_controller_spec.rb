require 'spec_helper'

describe Frontend::InquiriesController do
  
  describe "GET #new" do
    it "shows contact form" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST #create" do
    context "with valid info" do
      it "saves inquiry to database" do
        expect { post :create, :inquiry => FactoryGirl.attributes_for(:inquiry) }.to change(Physical::General::Inquiry,:count).by(1)
        expect { post :mad_lib_submit, :inquiry => FactoryGirl.attributes_for(:inquiry) }.to change(Physical::General::Inquiry,:count).by(1)
      end
      it "redirects contact form to success" do
        post :create, :inquiry => FactoryGirl.attributes_for(:inquiry)
        response.should redirect_to inquiry_success_path
      end
      it "redirects mad lib form to success" do
        post :mad_lib_submit, :inquiry => FactoryGirl.attributes_for(:inquiry)
        response.should redirect_to inquiry_mad_lib_success_path
      end
    end

    context "with invalid info" do
      it "does not save inquiry to datbase" do
        expect { post :create, :inquiry => FactoryGirl.attributes_for(:invalid_inquiry) }.to_not change(Physical::General::Inquiry,:count)
        expect { post :mad_lib_submit, :inquiry => FactoryGirl.attributes_for(:invalid_inquiry) }.to_not change(Physical::General::Inquiry,:count)
      end
      it "rerenders the :new template" do
        post :create, :inquiry => FactoryGirl.attributes_for(:invalid_inquiry)
        response.should render_template :new
      end
      it "rerenders the mad lib template" do
        post :mad_lib_submit, :inquiry => FactoryGirl.attributes_for(:invalid_inquiry)
        response.should render_template :new_mad_lib
      end
    end
  end

  describe "GET #success" do
    it "shows success message"
  end

end