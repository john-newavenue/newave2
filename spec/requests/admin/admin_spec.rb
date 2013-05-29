require 'spec_helper'

describe "Admin" do

  before(:all) {
    @admin = FactoryGirl.create(:admin_user)
    sign_in @admin
  }

  describe "admin home" do
    
    it 'should have descriptors' do
      visit admin_path
      expect(page).to have_title('Admin')
    end

    describe 'dashboard' do

      it 'should show recent activity' do
        pending 'verify recent activity block is shown'
      end

      it 'should show recent users list' do
        pending 'show a short list'
      end

    end

  end


end