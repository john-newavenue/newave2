require 'spec_helper'
require 'capybara/poltergeist'

include Capybara::DSL
Capybara.javascript_driver = :poltergeist

describe "Vendor user manages album", :js => true do

  # create album
  # see album
  # upload things, see them
  # edit something, delete something and save, see changes

  let(:vendor_user) { FactoryGirl.create(:vendor_user) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  before(:all) {
    vendor.add_member(vendor_user)
  }
  before(:each) { 
    sign_in vendor_user
  }

  it "should let vendor create album" do
    visit vendor_profile_path(:slug => vendor.slug)
    expect(page).to have_title(vendor.name)
    click_link 'Create Album'
    expect(page).to have_selector('#new_album_modal.open')
    # fill it out
    # click submit...
  end

end