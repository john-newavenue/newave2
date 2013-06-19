require 'spec_helper'

describe "Users CRM" do

  let(:staff_user) { FactoryGirl.create(:project_manager_user) }
  before(:each) { sign_in staff_user}

  describe "seeing users list in the CRM" do

    it "should display title" do
      visit crm_users_path
      expect(page).to have_title 'Users'
    end

    it "should paginate users" do
      25.times.each { FactoryGirl.create(:customer_user) }
      visit crm_users_path
      # there are 26 accounts (25 above, + staff_user)
      User.page(1).per_page(24).each do |user|
        expect(page).to have_xpath("//*[contains(@class,'users-list-block')]//a[@href='#{user_profile_path(user.slug)}']")
      end
      expect(page).to have_selector(".pagination .current")
      # so there should be at least 2 pages, we are on page 1, expect a next page
      expect(page).to have_selector(".pagination a[rel='next']")
    end

    it "should let me open a profile to view and edit" do
      visit crm_users_path
      user = User.last
      page.find("a[href='#{edit_crm_user_path(user)}']").click
      expect(page).to have_title("#{user.username}")

      fill_in 'user[profile_attributes][first_name]', :with => "Billy"
      click_button 'Save'
      expect(page).to have_selector('.alert-box.success')
      find_field('user[profile_attributes][first_name]').value.should eq('Billy')
    end

  end

end