require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "home" do
    before { visit root_path }
    it { should have_title('New Avenue') }
  end

  describe "about" do
    before { visit about_path }
    it { should have_title('About')}
  end

  describe "terms of service" do
    before { visit terms_path }
    it { should have_title('Terms of Service')}
  end

  describe "privacy" do
    before { visit privacy_path }
    it { should have_title('Privacy Policy')}
  end

end