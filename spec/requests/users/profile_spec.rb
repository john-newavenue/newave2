require 'spec_helper'

describe "Profile spec" do
  
  context "customer" do

    describe "own profile" do

      before(:all) { 
        @customer =  FactoryGirl.create(:customer_user)
        sign_in @customer
      }
      
      before(:each) { visit user_profile_path(@customer.slug) }

      it "should let user edit profile information" do
        visit edit_profile_path(@customer)
        fill_in 'profile[first_name]', :with => "John"
        fill_in 'profile[last_name]', :with => "Krasinski"
        attach_file 'profile[avatar]', Rails.root.join('spec', 'fixtures', 'johnkrasinski.jpg')
        click_button 'Update'
        expect(page).to have_content('Successfully updated your profile information.')
        expect(page).to have_selector('img.user-profile-picture[src*="krasinski.jpg"]')
      end
      
      it "should ask new customer to start first project" do
        visit user_profile_path(@customer.slug)
        page.has_button?('Start Your First Project')
      end

      it "should list projects for a customer and show new project button" do
        @project1 = FactoryGirl.create(:project)
        @project1.add_user_as_customer(@customer)
        @project2 = FactoryGirl.create(:project)
        @project2.add_user_as_customer(@customer)

        visit user_profile_path(@customer.slug)

        # is each project listed on the page?
        @customer.projects.each do |p|
          page.has_text? p.title
        end

        page.has_button?('New Project')
      end
    end

  end

end