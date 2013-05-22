require 'spec_helper'

describe Frontend::Users::ProfilesController do

  let!(:customer_user) { FactoryGirl.create(:customer_user)}
  let(:project_manager_user) { FactoryGirl.create(:admin_user)}
  let(:vendor_user) { FactoryGirl.create(:vendor_user)}

  it "should let customer edit own profile" do
    quick_check_1(customer_user, "get", :edit, 200, {:id => customer_user.id})
    quick_check_1(customer_user, "patch", :update, 302, {:id => customer_user.id, :profile => {:foo => "bar"}})
  end

  it "should let staff edit customer profile" do
    quick_check_1(project_manager_user, "get", :edit, 200, {:id => customer_user.id})
    quick_check_1(project_manager_user, "patch", :update, 302, {:id => customer_user.id, :profile => {:foo => "bar"}})
  end

  it "should not let others edit customer profile" do
    quick_check_1(vendor_user, "get", :edit, 403, {:id => customer_user.id})
    quick_check_1(vendor_user, "patch", :update, 403, {:id => customer_user.id, :profile => {:foo => "bar"}})
  end

end