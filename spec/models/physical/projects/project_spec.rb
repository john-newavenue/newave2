require 'spec_helper'

describe Physical::Project::Project do 

  context "creating a project" do

    project = Physical::Project::Project.create!(:title => "Sample Project", :description => "Project Description")

    it "should respond to certain fields" do

      expect(project).to respond_to(:title)
      expect(project).to respond_to(:description)
      expect(project).to respond_to(:address)
    end

    describe "validation" do
      
      let!(:project) { FactoryGirl.create(:project) }

      it "should have a title" do
        project.title = " "
        project.description = "Test"
        expect(project).not_to be_valid
      end
      it "should have a description" do
        project.title = "Test"
        project.description = " "
        expect(project).not_to be_valid
      end
      it "should build associated models" do
        expect(project.address).to_not be_nil
      end
    end



  end

end