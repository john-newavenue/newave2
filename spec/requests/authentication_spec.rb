require 'spec_helper'

describe 'Authentication' do

  describe "signing up" do

    describe "visitor signup" do

      before { visit new_user_registration_path }

      it "should have descriptors" do
        expect(page).to have_content('Sign up')
        expect(page).to have_title('Sign up')
      end

      it "should show errors to invalid information" do
        click_button "Sign up"
        expect(page).to have_content('Please correct the following:') 
      end

      
      it "should welcome valid signups" do # as a new client
        fill_in "user[email]", with: "test@example.com"
        fill_in "user[username]", with: "test user"
        fill_in "user[password]", with: "password"
        click_button "Sign up"
        debugger
        expect(page).to have_content ('Welcome! You have signed up successfully.')
        expect(page).to have_link('Sign Out', href: destroy_user_session_path )
      end
    end
  end


  describe "signing in" do

    before {
      visit root_path
      sign_out
    }

    let!(:user) { FactoryGirl.create(:user) }

    it "page should have descriptors" do
      visit new_user_session_path
      expect(page).to have_content('Sign in')
      expect(page).to have_title('Sign in')
    end

    it "should not let logged in users log in again" do
      sign_in user
      visit new_user_session_path
      expect(page).to have_content('You are already signed in.') 
    end

  end

  describe "signing out" do

    let!(:user) { FactoryGirl.create(:user) }

    it "should let me sign out" do
      sign_in user
      sign_out
      expect(page).to have_content('Signed out successfully.') 
      expect(page).to have_link('Sign In', href: new_user_session_path )
    end

  end

end