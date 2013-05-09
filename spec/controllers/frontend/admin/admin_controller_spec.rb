require 'spec_helper'

describe Frontend::Admin::AdminController do

  before(:all) {
    @admin = FactoryGirl.create(:admin)
  }

  describe "GET 'index'" do

    before(:each) {
      sign_out @admin
    }

    it 'allows admin viewers' do
      sign_in @admin
      get :index
      expect(response.code).to eq("200")
    end

    it 'redirects non-admin viewers' do
      get :index
      expect(response.code).to eq("302")
    end 

  end

end