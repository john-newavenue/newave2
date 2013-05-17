require 'spec_helper'

describe "Vendor profiles" do

  # let!(:vendor) { FactoryGirl.create(:vendor)}
  # let!(:vendor_user) { 
  #   u = FactoryGirl.create(:vendor_user) 
  #   vendor.add_member(vendor_user)
  # }
  
  # before { vendor.add_member(vendor_user) }

  shared_examples_for "vendor privileges" do 
    before(:each) {
      sign_in user
      vendor.add_member(user) if user.has_role? :vendor
    }

    it "can update" do
      visit edit_vendor_path(vendor)
      expect(page).to have_content("Edit Page")
      expect(page).to have_content(vendor.name)
      click_link "Edit Page"
      page.has_title? "Edit #{vendor.name}"
      new_name = "#{vendor.name} Blah"
      fill_in 'vendor[name]', :with => new_name
      click_button 'Update Vendor'
      page.has_title? new_name
      page.has_selector? "alert-box.success"
    end
  end

  shared_examples_for "staff privileges" do

    before(:each) {sign_in user}

    it "can create a vendor profile" do
      visit new_vendor_path
      page.has_title? "New Vendor"
      fill_in 'vendor[name]', :with => "Some Vendor"
      fill_in 'vendor[description]', :with => "This is a description"
      choose("vendor_vendor_type_id_1")
      click_button 'Create Vendor'
      page.has_title? "Some Vendor"
      page.has_selector? "alert-box.success"
    end

    # it "can delete a vendor profile" do
    #   visit delete_vendor_path(vendor)
    #   expect(page.title).to have_content("Delete Vendor")
    #   expect(page).to have_content("Are you sure")
    #   expect(page).to have_content(vendor.name)
    # end

  end

  describe "privileges of a vendor" do
    it_should_behave_like "vendor privileges" do
      let!(:user) { FactoryGirl.create(:vendor_user) }
      let!(:vendor) { FactoryGirl.create(:vendor) }
    end
  end

  describe "privileges of staff" do
    [:project_manager_user, :admin_user].each do |sample_user|
      it_should_behave_like "staff privileges" do
        let(:user) { FactoryGirl.create(sample_user) }
        let(:vendor) { FactoryGirl.create(:vendor) }
      end
      it_should_behave_like "vendor privileges" do
        let(:user) { FactoryGirl.create(sample_user) }
        let(:vendor) { FactoryGirl.create(:vendor) }
      end
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