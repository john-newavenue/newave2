require 'spec_helper'

describe Physical::Project::Project do 

  context "behavior" do

    let!(:customer) { FactoryGirl.create(:customer_user) }
    let!(:project) { FactoryGirl.create(:project) }
    let!(:other_project) { FactoryGirl.create(:project) }

    describe "validation" do

      it "should respond to certain fields" do
        expect(project).to respond_to(:title)
        expect(project).to respond_to(:description)
        expect(project).to respond_to(:address)
        expect(project).to respond_to(:items)
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

    describe "assocations and membership" do
      it "should let me add a client" do
        expect(project.add_user_as_customer(customer)).to be_true
      end

      it "should let me retrieve associated project items only" do
        3.times.each { |i| FactoryGirl.create(:project_item, :project => project) }
        3.times.each { |i| FactoryGirl.create(:project_item, :project => other_project) }
        expect(project.items.map(&:id) & other_project.items.map(&:id)).to be_empty
      end

      it "should let me build a project item by association" do
        item_to_build = project.items.create
        expect(item_to_build.project).to eq(project)
        expect(project.items.map(&:id)).to include item_to_build.id
      end

      it "should have a scope for recency by updated_at" do
        p1 = FactoryGirl.create(:project)
        p2 = FactoryGirl.create(:project)
        p3 = FactoryGirl.create(:project)
        p4 = FactoryGirl.create(:project)
        p2.touch
        p3.touch
        ids = [p1,p2,p3,p4].map(&:id)
        q = Physical::Project::Project.by_recency.where(id: ids)
        expect(q.map(&:id)).to eq([p3,p2,p4,p1].map(&:id))
      end

      it "should update project's updated_at if project item is created (by assocation)" do
        old_updated_at = project.updated_at
        new_item = project.items.create
        new_updated_at = project.updated_at
        expect(old_updated_at).to_not eq(new_updated_at)
      end


    end

  end

end