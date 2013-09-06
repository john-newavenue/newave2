require 'spec_helper'

describe "Featured Architects" do

  let(:customer_user) { FactoryGirl.create(:customer_user)}

  let!(:featured_architects) {
    # create some vendors, make them featured
    users = []
    (1..5).to_a.shuffle.each do |n|
      user = FactoryGirl.create(:vendor_user)
      profile = user.profile
      profile.first_name = Faker::Name.first_name
      profile.last_name = Faker::Name.last_name
      profile.is_featured_architect = true
      profile.featured_architect_position = n
      profile.save
      users.push(user)
    end
    users
  }

  before(:all) { visit featured_architects_path }

  context "as a visitor" do
    
    before(:each) { 
      sign_out
      visit featured_architects_path
    }

    it "featured architects page should display architects in order" do
      expect(page).to have_content "Featured Architects"
      f = Physical::User::UserProfile.includes(:user).where('is_featured_architect IS TRUE').order('featured_architect_position ASC, id DESC')
      f.each_with_index { |item, index|
        expect(page).to have_selector("ul.featured-architects li:nth-child(#{index+1})", text: item.first_name)
      }
    end

  end

  context "as an architect" do

    let(:featured_architect_user) { featured_architects.sample }

    it "test" do
      puts featured_architect_user
    end

  end


end