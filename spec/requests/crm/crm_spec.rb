require 'spec_helper'

describe "Admin" do

  before(:all) {
    @admin = FactoryGirl.create(:admin_user)
    sign_in @admin
  }

  describe "admin home" do
    
    it 'should have descriptors' do
      visit crm_path
      expect(page).to have_title('Admin')
    end

    describe 'dashboard' do

      it 'should show recent activity' do
        pending 'verify recent activity block is shown'
      end

      it 'should show recent users list' do
        5.times.each do
          FactoryGirl.create(:customer_user)
          FactoryGirl.create(:vendor_user)
        end
        
        visit crm_path

        User.limit(10).each do |user|
          expect(page).to have_xpath("//*[contains(@class,'users-list-block')]//a[@href='#{user_profile_path(user.slug)}']")
        end
      end

      it 'should show recent projects' do
        5.times.each do
          FactoryGirl.create(:project)
        end
        
        visit crm_path

        Physical::Project::Project.limit(5).each do |project|
          expect(page).to have_xpath("//*[contains(@class,'projects-list-block')]//a[@href='#{project_path(project)}']")
        end
      end

    end

  end


end