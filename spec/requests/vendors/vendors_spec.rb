require 'spec_helper'

describe "Vendor profiles" do

  # let!(:vendor) { FactoryGirl.create(:vendor)}
  # let!(:vendor_user) { 
  #   u = FactoryGirl.create(:vendor_user) 
  #   vendor.add_member(vendor_user)
  # }
  
  # before { vendor.add_member(vendor_user) }

  shared_examples_for "a vendor can do stuff" do 
    before(:each) {
      sign_in user
      vendor.add_member(user) if user.has_role? :vendor
    }

    it "can update" do
      visit edit_vendor_path(vendor)
      expect(page).to have_content("Edit Page")
      expect(page).to have_content(vendor.name)
    end
  end

  # shared_examples_for "staff privileges" do
  #   let(:user) { described_class }
  #   before(:all) { sign_in user }
  # end

  describe "privileges" do
    it_should_behave_like "a vendor can do stuff" do
      let!(:user) { FactoryGirl.create(:vendor_user) }
      let!(:vendor) { FactoryGirl.create(:vendor) }
    end
  end

  # describe "viewing" do
  #   it "should let a PM make a profile"
  # end

  # describe "creating" do

  # end

  # describe "updating" do

  # end

  # describe "deleting" do

  # end


end