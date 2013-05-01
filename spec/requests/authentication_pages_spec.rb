require 'spec_helper'

describe 'Authentication' do

  subject { page }

  describe "sign in page" do
    before { visit new_user_session_path }
    it { should have_content('Sign in')}
    it { should have_title('Sign in')}
  end

  describe "signin" do
    before { visit new_user_session_path }

    describe "with invalid information" do
      before { click_button "Sign in"}
      it { should have_error_message('Invalid') }
    end

    describe "with valid information" do # as a new client
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "Sign in"
      end

      it { should have_link('Sign out', href: destroy_user_session_path )}
    end

  end

end