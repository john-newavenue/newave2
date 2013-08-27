require 'spec_helper'

describe Frontend::Crm::InvitationsController do

  let!(:admin_user) { FactoryGirl.create(:admin_user) }
  let!(:project_manager_user) { FactoryGirl.create(:project_manager_user) }
  let!(:other_user) { FactoryGirl.create(:customer_user) }

  before(:all) {
    # invite a user
    atts = FactoryGirl.attributes_for(:customer_user)
    invited_customer = User.invite!(:email => atts[:email], :username => atts[:email]) do |u|
        u.skip_invitation = true
    end
    # invited_customer_params = {:id => invited_customer.id}
  }

  describe "index" do
    it "should display something" do
      pending 'this should return list of invitations'
    end
  end

  describe "show" do

    action = :show
    method = "get"
    let!(:params) {  }

    pending "view"

  end

  describe "edit" do

    action = :show
    method = "get"
    let!(:params) {  }

    pending "edit"

  end

  describe "update" do

    action = :show
    method = "get"
    let!(:params) {  }

    pending "update"

  end

  describe "new" do

    action = :new
    method = "get"
    let!(:params) { {} }

    context 'authorization' do
      describe "admin" do it "OK" do quick_check_1(admin_user, method, action, 200, params) end end
      describe "pm" do it "OK" do quick_check_1(project_manager_user, method, action, 200, params) end end
      describe "customer" do it "not OK" do quick_check_1(other_user, method, action, 403, params) end end       
    end

  end

  describe "delete" do

    action = :show
    method = "get"
    let!(:params) {  }

    pending "delete"

  end

  describe "destroy" do

    action = :show
    method = "get"
    let!(:params) {  }

    pending "destroy"

  end



end