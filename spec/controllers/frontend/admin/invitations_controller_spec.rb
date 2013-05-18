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
  
  shared_examples_for "staff privileges" do
    before(:each) { sign_in user }

    it "new" do 
      quick_check_1(user, "get", :new, 200)
    end
    # it "create" do 
    #   quick_check_1(user, "post", :create, 200)
    # end
    # it "show" do 
    #   quick_check_1(user, "get", :show, 200, invited_customer_params)
    # end
    # it "edit" do 
    #   quick_check_1(user, "get", :edit, 200, invited_customer_params)
    # end
    # it "update" do 
    #   quick_check_1(user, "patch", :update, 200)
    # end
    # it "update" do 
    #   quick_check_1(user, "put", :update, 200)
    # end
    # it "delete" do 
    #   quick_check_1(user, "get", :delete, 200)
    # end
    # it "destroy" do 
    #   quick_check_1(user, "delete", :destroy, 200)
    # end
  end

  shared_examples_for "other privileges" do
    before(:each) { sign_in user }
    # it "new" do 
    #   quick_check_1(user, "get", :new, 403 )
    # end
    # it "create" do 
    #   quick_check_1(user, "post", :create, 403 )
    # end
    # it "show" do 
    #   quick_check_1(user, "get", :show, 403,invited_customer_params)
    # end
    # it "edit" do 
    #   quick_check_1(user, "get", :edit, 403 )
    # end
    # it "update" do 
    #   quick_check_1(user, "patch", :update, 403 )
    # end
    # it "update" do 
    #   quick_check_1(user, "put", :update, 403 )
    # end
    # it "delete" do 
    #   quick_check_1(user, "get", :delete, 403 )
    # end
    # it "destroy" do 
    #   quick_check_1(user, "delete", :destroy, 403) 
    # end
  end

  describe "index" do
    it "should display something" do
      pending 'this should return list of invitations'
    end
  end

  describe "privileges of staff" do
    [:admin_user, :project_manager_user].each do |sample_user|
      it_should_behave_like "staff privileges" do
        let(:user) { FactoryGirl.create(sample_user)}
      end
    end
  end

  # describe "privileges of other" do
  #   it_should_behave_like "other privileges" do
  #     let(:user) { FactoryGirl.create(:customer_user)}
  #   end 
  # end

  # describe "new" do

  #   action = :new
  #   method = "get"

  #   it "should let admin through" do
  #     quick_check_1(admin_user, method, action, 200)
  #   end

  #   it "should let project managers through" do
  #     quick_check_1(project_manager_user, method, action, 200)
  #   end

  #   it "should forbid customers" do
  #     quick_check_1(other_user, method, action, 403)
  #   end

  # end

  # describe "create" do

  #   action = :create
  #   method = "post"

  #   # test valid request actually creates record

  #   it "should let admin through" do
  #     quick_check_1(admin_user, method, action, 200)
  #   end

  #   it "should let project managers through" do
  #     quick_check_1(project_manager_user, method, action, 200)
  #   end

  #   it "should forbid vendors" do
  #     quick_check_1(other_user, method, action, 403)
  #   end

  # end

  # describe "show" do

  #   action = :show
  #   method = "get"
  #   let!(:params) { {:slug => vendor.slug} }

  #   it "should return a page " do
  #     quick_check_1(User.new, method, action, 200, params)
  #   end

  # end

  # describe "edit" do

  #   action = :edit
  #   method = "get"
  #   let!(:params) { {:id => vendor.id} }

  #   it "should let admin through" do
  #     quick_check_1(admin_user, method, action, 200, params)
  #   end

  #   it "should let project managers through" do
  #     quick_check_1(project_manager_user, method, action, 200, params)
  #   end

  #   it "should not allow nonmember vendors" do
  #     quick_check_1(other_vendor_user, method, action, 403, params)
  #   end

  #   it "should allow member vendors" do
  #     vendor.add_member(vendor_user)
  #     quick_check_1(vendor_user, method, action, 200, params)
  #   end

  #   it "should forbid customers" do
  #     quick_check_1(customer_user, method, action, 403, params)
  #   end

  # end

  # describe "update" do

  #   # TODO: test valid request actually updates record    

  #   action = :update
  #   method = "patch"
  #   let!(:params) { {:id => vendor.id} }

  #   it "should let admin through" do
  #     quick_check_1(admin_user, method, action, 200, params)
  #   end

  #   it "should let project managers through" do
  #     quick_check_1(project_manager_user, method, action, 200, params)
  #   end

  #   it "should not allow nonmember vendors" do
  #     quick_check_1(other_vendor_user, method, action, 403, params)
  #   end

  #   it "should allow member vendors" do
  #     vendor.add_member(vendor_user)
  #     quick_check_1(vendor_user, method, action, 200, params)
  #   end

  #   it "should forbid customers" do
  #     quick_check_1(customer_user, method, action, 403, params)
  #   end

  # end

  # describe "destroy" do

  #   # TODO: test valid request actually destroys record

  #   action = :destroy
  #   method = "delete"
  #   let!(:params) { {:id => vendor.id} }

  #   it "should let admin through" do
  #     quick_check_1(admin_user, method, action, 200, params)
  #   end

  #   it "should let project managers through" do
  #     quick_check_1(project_manager_user, method, action, 200, params)
  #   end

  #   it "should forbid vendors" do
  #     quick_check_1(vendor_user, method, action, 403, params)
  #   end

  #   it "should forbid customers" do
  #     quick_check_1(customer_user, method, action, 403, params)
  #   end

  # end

end