require 'spec_helper'

describe "Inquiry pages" do

  describe "submitting contact form as an anonymous visitor" do
    
    before(:each) { visit new_inquiry_path }

    it "has proper page elements" do
      expect(page).to have_title("Contact")
      expect(page).to have_field("inquiry[first_name]")
      expect(page).to have_field("inquiry[last_name]")
      expect(page).to have_field("inquiry[email]")
      expect(page).to have_field("inquiry[phone_number]")
      expect(page).to have_field("inquiry[message]")
    end

    it "should not let me enter invalid information" do
      click_button "Send"
      expect(page).to have_content("Something went wrong.")
    end

    it "should give me a success page upon valid submission" do
      fill_in "inquiry[first_name]", :with => "Ned"
      fill_in "inquiry[last_name]", :with => "Stark"
      fill_in "inquiry[email]", :with => "nedstark@winterfell.com"
      fill_in "inquiry[message]", :with => "I want to build a house."
      click_button "Send"
      expect(page).to have_title("Message Sent")
      expect(page).to have_content("success")
    end

  end

  describe "submitting contact form as logged in user" do

    let!(:user) { FactoryGirl.create (:user) }

    it "should include user information in the record" do
      sign_in user
      visit new_inquiry_path
      fill_in "inquiry[first_name]", :with => "Jon"
      fill_in "inquiry[last_name]", :with => "Snow"
      fill_in "inquiry[email]", :with => user.email
      fill_in "inquiry[message]", :with => "I want to build a house."
      click_button "Send"
      inquiry = Physical::General::Inquiry.order('created_at DESC').first
      expect(inquiry.first_name).to eql("Jon")
      expect(inquiry.last_name).to eql("Snow")
      expect(inquiry.user).to eql(user)
    end
  end

end