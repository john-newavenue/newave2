require 'spec_helper'

describe "Vendor Pages" do

  shared_examples_for "manage members, edit info" do 
    before(:each) {
      sign_in user
      # project manager and admin should be able to do these examples already for any vendor page
      # a vendor user is added to a particular vendor so that they can manage that page
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
      attach_file 'vendor[logo]', Rails.root.join('spec','files','vendors','test-logo.jpg')
      click_button 'Update Vendor'
      page.has_title? new_name
      page.has_selector? "alert-box.success"
    end

    describe "managing vendor staff" do
      before(:each) {
        visit vendor_path(vendor)
        click_link 'Manage Staff'
      }

      it "shows the right content" do
        page.has_title? "Manage Staff"
        vendor.members.each do |user|
          page.has_selector?("li", :text => user.username)
        end
      end

      it "lets staff be added and removed" do
        new_vendor_user = FactoryGirl.create(:vendor_user)
        fill_in 'added_vendor_member[username]', :with => new_vendor_user.username
        click_button "Add"
        page.has_selector? "alert-box.success"
        page.has_selector?("div.user-#{new_vendor_user.id}", :text => new_vendor_user.username)
        click_link( "vendor-member-delete-#{new_vendor_user.id}")
        page.should_not have_selector("div.user-#{new_vendor_user.id}", :text => new_vendor_user.username)
      end

      pending "notify staff that they've been invited"

    end
  end

  shared_examples_for "manage vendors" do

    before(:each) {sign_in user}

    it "can create a vendor" do
      visit new_vendor_path
      page.has_title? "New Vendor"
      fill_in 'vendor[name]', :with => new_vendor[:name]
      fill_in 'vendor[description]', :with => new_vendor[:description]
      choose("vendor_vendor_type_id_1")
      click_button 'Create Vendor'
      page.has_title? new_vendor[:name]
      page.has_selector? "alert-box.success"
    end

    pending "delete vendor"

  end

  [:project_manager_user, :admin_user].each do |sample_user|
    it_should_behave_like "manage vendors" do
      let(:user) { FactoryGirl.create(sample_user) }
      let(:new_vendor) { FactoryGirl.attributes_for(:vendor) }
    end
  end

  [:project_manager_user, :admin_user, :vendor_user].each do |sample_user|
    it_should_behave_like "manage members, edit info" do
      let(:user) { FactoryGirl.create(sample_user) }
      let(:vendor) { FactoryGirl.create(:vendor) }
    end
  end

  describe "viewing a vendor profile" do

    let(:vendor) {
      vendor = FactoryGirl.create(
        :vendor, 
        :name => "Joe's Firm",
        :description => "This that something."
      )
      5.times { vendor.add_member(FactoryGirl.create(:vendor_user) ) }
      vendor
    }

    it "should have company info and members visible" do
      visit vendor_profile_path(vendor.slug)
      page.has_content? vendor.name
      vendor.members.each do |member|
        expect(page).to have_link(member.username, user_profile_path(member.slug))
      end
    end
  end

  describe "viewing vendors" do
    it "should show architects" do
      visit architects_path
      expect(page).to have_title('Architects')
      Physical::Vendor::Vendor.architects.each do |v|
        expect(page).to have_link(v.name, vendor_profile(v.slug))
      end
    end
  end

  pending "company work visible"
  pending "vendor albums"
  

end