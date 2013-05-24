require 'spec_helper'

describe Physical::Project::Project do 

  context "creating a project" do

    let!(:customer) { FactoryGirl.create(:customer_user) }
    let!(:project) { FactoryGirl.create(:project) }

    describe "validation" do

      it "should respond to certain fields" do
        expect(project).to respond_to(:title)
        expect(project).to respond_to(:description)
        expect(project).to respond_to(:address)
      end

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

      pending "replace not valid with field error counts"
      
    end

    describe "membership" do
      it "should let me add a client" do
        expect(project.add_user_as_customer(customer)).to be_true
      end
    end

  end

end