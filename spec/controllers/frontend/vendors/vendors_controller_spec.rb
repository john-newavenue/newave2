require 'spec_helper'

describe Frontend::Vendors::VendorsController do

  let!(:admin_user) { FactoryGirl.create(:admin_user) }
  let!(:project_manager_user) { FactoryGirl.create(:project_manager_user) }
  let!(:vendor_user) { FactoryGirl.create(:vendor_user) }
  let!(:customer_user) { FactoryGirl.create(:customer_user) }
  let!(:vendor) { FactoryGirl.create(:vendor) }

  # before(:each) {
  #   [admin_user, project_manager_user, vendor_user, customer_user].each { |user| sign_out user }
  # }

  describe "index" do
    it "should display something" do
      pending 'this should just return nothing or redirect to /b/'
    end
  end

  describe "new" do

    action = :new
    method = "get"

    it "should let admin through" do
      quick_check_1(admin_user, method, action, 200)
    end

    it "should let project managers through" do
      quick_check_1(project_manager_user, method, action, 200)
    end

    it "should forbid vendors" do
      quick_check_1(vendor_user, method, action, 403)
    end

    it "should forbid customers" do
      quick_check_1(customer_user, method, action, 403)
    end

  end

  describe "create" do

    action = :create
    method = "post"

    it "should let admin through" do
      # CREATE SOME VENDOR W/VENDOR TYPE
      expect( post :create, SOMETHING).to change(Physical::Vendor::Vendor, :count).by(1)
    end

    it "should let project managers through" do
      quick_check_1(project_manager_user, method, action, 200)
    end

    it "should forbid vendors" do
      quick_check_1(vendor_user, method, action, 403)
    end

    it "should forbid customers" do
      quick_check_1(customer_user, method, action, 403)
    end

  end

  describe "show" do



  end

  describe "edit" do

    action = :edit
    method = "get"

    it "should let admin through" do
      quick_check_1(admin_user, method, action, 200)
    end

    it "should let project managers through" do
      quick_check_1(project_manager_user, method, action, 200)
    end

    it "should allow vendors" do
      quick_check_1(vendor_user, method, action, 200)
    end

    it "should forbid customers" do
      quick_check_1(customer_user, method, action, 403)
    end

  end

  describe "update" do

    action = :update
    method = "patch"

    it "should let admin through" do
      quick_check_1(admin_user, method, action, 200)
    end

    it "should let project managers through" do
      quick_check_1(project_manager_user, method, action, 200)
    end

    it "should allow vendors" do
      quick_check_1(vendor_user, method, action, 200)
    end

    it "should forbid customers" do
      quick_check_1(customer_user, method, action, 403)
    end

  end

  describe "destroy" do

    action = :destroy
    method = "delete"

    it "should let admin through" do
      quick_check_1(admin_user, method, action, 200)
    end

    it "should let project managers through" do
      quick_check_1(project_manager_user, method, action, 200)
    end

    it "should forbid vendors" do
      quick_check_1(vendor_user, method, action, 403)
    end

    it "should forbid customers" do
      quick_check_1(customer_user, method, action, 403)
    end

  end

end