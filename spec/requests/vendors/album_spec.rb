require 'spec_helper'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
Capybara.javascript_driver = :poltergeist
Capybara.save_and_open_page_path = "#{::Rails.root}/tmp/screenshots"

describe "Vendor user manages album", :js => true do

  # create album
  # see album
  # upload things, see them
  # edit something, delete something and save, see changes

  before(:all) {
    @vendor_user = FactoryGirl.create(:vendor_user)
    @vendor = FactoryGirl.create(:vendor)
    @vendor.add_member(@vendor_user)
  }

  before(:each) {
    sign_in @vendor_user
  }

  it "should let vendor create album" do
    visit vendor_profile_path(:slug => @vendor.slug)
    expect(page).to have_title(@vendor.name)
    click_link "Create Album"
    take_screenshot
    expect(page).to have_selector('#new_album_modal.open')
    fill_in "album[title]", :with => "Some Album"
    click_button 'Create Album'
    sleep 2 # let the page do its thing...
    expect(page).to have_title("Some Album")
    take_screenshot
  end

  it "should let vendor add stuff to the album" do
  end

end