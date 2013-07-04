require 'spec_helper'

describe Physical::Project::ProjectItem do

  describe "properties" do 

    it "should respond to " do
      project_item = Physical::Project::ProjectItem.new
      %w(project body type deleted_at created_at updated_at).each do |prop|
        expect(project_item).to respond_to(prop.to_sym)
      end
    end

    pending "soft deletion check"
    pending "validation check"

  end

end