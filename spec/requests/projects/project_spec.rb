require 'spec_helper'

describe 'Project Interaction' do

  context "customer" do

    let!(:customer)  { FactoryGirl.create(:customer_user) }
    before(:each) { sign_in customer }
    
    describe "can create a project" do
      it "should let customer create a project" do
        project_title = "My Project"
        visit new_project_path
        fill_in "project[title]", :with => project_title
        fill_in "project[description]", :with => "This is a description"
        click_button "Create Project"
        page.has_button? "Edit Project"
        page.has_text? project_title
      end
    end

    describe "can edit project description" do

      let!(:project) { FactoryGirl.create(:project) }
      before(:each) { 
        project.add_user_as_client(customer)
        visit edit_project_path(project)
      }

      it "should not take invalid info" do
        fill_in "project[title]", :with => " "
        fill_in "project[address_attributes][line_1]", :with => " "
        click_button "Update Project"
        page.has_selector? "alert-box.alert"
        page.has_selector? ".error #project_title"
        page.has_selector? ".error #project_address_attributes_line_1"
      end

      it "should take valid info" do
        {
          "project[title]" => "My Cool Project",
          "project[description]" => "My project is really cool.",
          "project[address_attributes][line_1]" => "123 Fake St",
          "project[address_attributes][city]" => "Simcity",
          "project[address_attributes][state]" => "CA",
          "project[address_attributes][zip_or_postal_code]" => "00000"
        }.each do |key, value|
          fill_in key, :with => value
        end
        click_button "Update Project"
        page.has_selector? "alert-box.alert", :count => 0
      end

      it "should let them choose a cover photo" do
        pending "g"
      end

    end

  end

end