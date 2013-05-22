require 'spec_helper'

describe "Invitations" do

  let(:admin_user) { FactoryGirl.create(:admin_user)}
  let(:project_manager_user) { FactoryGirl.create(:project_manager_user)}

  context "admin" do

    describe "view" do

    end

    describe "sending" do

    end

  end

  context "project manager" do

    before(:each) { sign_in admin_user }

    describe "viewing" do
      it "should list all invitations" do
        visit admin_invitations_path
        page.has_title? "Invitations"
        User.invited.each { |u| page.has_content? user.username }
      end
    end

  end

end