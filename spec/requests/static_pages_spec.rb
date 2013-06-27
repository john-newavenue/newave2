require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "home" do
    before { visit root_path }
    it { should have_title('New Avenue') }
  end

  describe "about" do
    before { visit about_path }
    it { should have_title('What is New Avenue?')}
  end

  describe "terms of service" do
    before { visit terms_path }
    it { should have_title('Terms of Service')}
  end

  describe "privacy" do
    before { visit privacy_path }
    it { should have_title('Privacy Policy')}
  end

  describe "team" do
    before { visit team_path }
    it { should have_title('Team')}
  end

  describe "faqs" do
    before { visit faqs_path }
    it { should have_title('Frequently Asked Questions')}
  end

  describe "investors" do
    before { visit investors_path }
    it { should have_title('Investors')}
  end

  describe "press" do
    before { visit press_path }
    it { should have_title('Press')}
  end

end