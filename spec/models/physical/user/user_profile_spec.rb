require 'spec_helper'

describe Physical::User::UserProfile do

  let(:profile) { 
    user = FactoryGirl.create(:user)
    user.profile
  }

  it "should have an avatar" do
    expect(profile).to respond_to(:avatar)
  end

  it "should be created upon user creation" do
    expect(profile).to_not be_nil
  end

  it "should respond to fields" do
    %w(first_name middle_name last_name bio website_title website_url address).each do |f|
      expect(profile).to respond_to(f.to_sym)
    end    
  end

  context "vendor users" do

    let!(:vendor_user) { FactoryGirl.create(:vendor_user)}

    it "should automatically create a featured work album for vendors" do
      expect(vendor_user.profile.featured_work_album.id).to_not be_nil
    end
  end



end