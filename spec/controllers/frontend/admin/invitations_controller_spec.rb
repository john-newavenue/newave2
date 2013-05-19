require 'spec_helper'

describe Frontend::Admin::InvitationsController do

  let!(:admin_user) { FactoryGirl.create(:admin_user) }
  let!(:project_manager_user) { FactoryGirl.create(:project_manager_user) }
  let!(:other_user) { FactoryGirl.create(:customer_user) }

  before(:all) {
    atts = FactoryGirl.attributes_for(:customer_user)
    invited_customer = User.invite!(:email => atts[:email], :username => atts[:email]) do |u|
        u.skip_invitation = true
    end
    invited_customer_params = {:id => invited_customer.id}
  }

  describe "index" do
    it "should display something" do
      pending 'this should return list of invitations'
    end
  end

  

end