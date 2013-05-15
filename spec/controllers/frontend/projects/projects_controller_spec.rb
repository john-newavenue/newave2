require 'spec_helper'

describe Frontend::Projects::ProjectsController do

  let!(:project) { FactoryGirl.create(:project) }
  let!(:customer) { FactoryGirl.create(:customer) }
  let!(:other_customer) { FactoryGirl.create(:customer) }

  before(:all) {project.add_user_as_client(customer)}

  describe "GET 'index" do
    it "should display something" do

    end
  end

  describe "GET 'edit'" do

    it "should redirect (to login) for anonymous user" do
      get :edit, :id => project.id
      expect(response.code).to eq("302")
    end

    it "should display forbidden for non-project participant" do
      sign_in other_customer
      get :edit, :id => project.id
      expect(response.code).to eq("403")
    end

    it "should be viewable for customer" do
      sign_in customer
      get :edit, :id => project.id
      expect(response.code).to eq("200")
    end

  end

end