require 'spec_helper'

describe Frontend::Vendors::VendorsController do

  let!(:admin_user) { FactoryGirl.create(:admin_user) }
  let!(:project_manager_user) { FactoryGirl.create(:project_manager_user) }
  let!(:vendor_user) { FactoryGirl.create(:vendor_user) }
  let!(:other_vendor_user) { FactoryGirl.create(:vendor_user) }
  let!(:customer_user) { FactoryGirl.create(:customer_user) }
  let!(:vendor) { FactoryGirl.create(:vendor) }

  describe "index" do
    it "should display something" do
      pending 'this should just return nothing or redirect to /b/'
    end
  end

  describe "show" do

    action = :show
    method = "get"
    let!(:params) { {:slug => vendor.slug} }

    it "should return a page (for anyone)" do
      quick_check_1(User.new, method, action, 200, params)
    end

  end

  describe "new" do

    action = :new
    method = "get"
    let!(:params) { {} }

    context 'authorization' do
      describe "admin" do it "OK" do quick_check_1(admin_user, method, action, 200, params) end end
      describe "pm" do it "OK" do quick_check_1(project_manager_user, method, action, 200, params) end end
      describe "other vendor" do it "not OK" do quick_check_1(other_vendor_user, method, action, 403, params) end end
      describe "vendor" do it "not OK" do vendor.add_member(vendor_user); quick_check_1(vendor_user, method, action, 403, params) end end
      describe "customer" do it "not OK" do quick_check_1(customer_user, method, action, 403, params) end end       
    end

  end

  describe "create" do

    action = :create
    method = "post"
    let!(:params) { {:vendor => {:foo => "bar"} } }

    # TODO: expect( post :create, SOMETHING).to change(Physical::Vendor::Vendor, :count).by(1)
    # test valid request actually creates record

    context 'authorization' do
      describe "admin" do it "OK" do quick_check_1(admin_user, method, action, 200, params) end end
      describe "pm" do it "OK" do quick_check_1(project_manager_user, method, action, 200, params) end end
      describe "other vendor" do it "not OK" do quick_check_1(other_vendor_user, method, action, 403, params) end end
      describe "vendor" do it "not OK" do vendor.add_member(vendor_user); quick_check_1(vendor_user, method, action, 403, params) end end
      describe "customer" do it "not OK" do quick_check_1(customer_user, method, action, 403, params) end end       
    end

  end

  describe "edit" do

    action = :edit
    method = "get"
    let!(:params) { {:id => vendor.id} }

    context 'authorization' do
      describe "admin" do it "OK" do quick_check_1(admin_user, method, action, 200, params) end end
      describe "pm" do it "OK" do quick_check_1(project_manager_user, method, action, 200, params) end end
      describe "other vendor" do it "OK" do quick_check_1(other_vendor_user, method, action, 403, params) end end
      describe "vendor" do it "OK" do vendor.add_member(vendor_user); quick_check_1(vendor_user, method, action, 200, params) end end
      describe "customer" do it "not OK" do quick_check_1(customer_user, method, action, 403, params) end end       
    end

  end

  describe "update" do

    # TODO: test valid request actually updates record    

    action = :update
    method = "patch"
    let!(:params) {{ :id => vendor.id, :vendor => FactoryGirl.attributes_for(:vendor)  }}

    context 'authorization' do
      describe "admin" do it "OK" do quick_check_1(admin_user, method, action, 302, params) end end
      describe "pm" do it "OK" do quick_check_1(project_manager_user, method, action, 302, params) end end
      describe "other vendor" do it "not OK" do quick_check_1(other_vendor_user, method, action, 403, params) end end
      describe "vendor" do it "OK" do vendor.add_member(vendor_user); quick_check_1(vendor_user, method, action, 302, params) end end
      describe "customer" do it "not OK" do quick_check_1(customer_user, method, action, 403, params) end end       
    end

  end

  describe "destroy" do

    # TODO: test valid request actually destroys record

    action = :destroy
    method = "delete"
    let!(:params) { {:id => vendor.id} }

    context 'authorization' do
      describe "admin" do it "OK" do quick_check_1(admin_user, method, action, 200, params) end end
      describe "pm" do it "OK" do quick_check_1(project_manager_user, method, action, 200, params) end end
      describe "other vendor" do it "not OK" do quick_check_1(other_vendor_user, method, action, 403, params) end end
      describe "vendor" do it "not OK" do vendor.add_member(vendor_user); quick_check_1(vendor_user, method, action, 403, params) end end
      describe "customer" do it "not OK" do quick_check_1(customer_user, method, action, 403, params) end end       
    end

  end

end