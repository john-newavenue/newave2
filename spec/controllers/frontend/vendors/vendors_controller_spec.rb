require 'spec_helper'

describe Frontend::Vendors::VendorsController do

  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:project_manager) { FactoryGirl.create(:project_manager_user) }
  let!(:vendor) { FactoryGirl.create(:vendor) }
  let!(:customer) { FactoryGirl.create(:customer_user) }

  describe "GET 'index" do
    it "should display something" do
      pending 'this should just return nothing or redirect to /b/'
    end
  end

  pending "all permission tests"

end