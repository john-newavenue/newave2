require 'spec_helper'

describe 'Managing Featured Architects' do

  let(:admin_user) { FactoryGirl.create(:admin_user)}
  let!(:vendor_users) { 
    # create some vendors
    vendor_users = []
    5.times.each do |n| 
      vendor_users.push(FactoryGirl.create(:vendor_user))
    end
    vendor_users
  }

  before(:each) { sign_in admin_user }


  context "managing as an admin" do

    describe 'view listing' do
      it "should list all vendors" do
        visit crm_featured_architects_path
        expect(page).to have_title('Featured Architects')
        vendor_users.each do |vendor_user|  
          expect(page).to have_content(vendor_user.username)
          expect(page).to have_link('Edit', :href => edit_crm_featured_architect_path(vendor_user.profile))
        end

      end
    end

    describe "editing" do
      it "should let the architect profile be edited to be featured" do
        # start with a vendor that is not featured
        vendor_user = vendor_users.last
        vendor_user_profile = vendor_user.profile
        vendor_user_profile.is_featured_architect = false
        vendor_user_profile.save
        # update the vendor: feature and position
        visit crm_featured_architects_path
        click_link('Edit', :href => edit_crm_featured_architect_path(vendor_user_profile))
        expect(page).to have_content "Featured Architect: #{vendor_user_profile.first_name} #{vendor_user_profile.last_name} (#{vendor_user.username})"
        expect(find('[name="profile[is_featured_architect]"][type="checkbox"]').checked?).to be_false
        check "profile[is_featured_architect]"
        fill_in 'profile[featured_architect_position]', :with => 1
        click_button 'Save Changes' # should redirect back to listing
        expect(page).to have_content 'Featured Architects'
        # visit public featured architects page, should show only the featured architects
        
      end
    end

  end

end