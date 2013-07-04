require 'spec_helper'

describe Physical::Project::ProjectItemAsset do

  describe "properties" do 

    it "should respond to " do
      project_item_asset = Physical::Project::ProjectItemAsset.new
      %w(project_item album_item created_at updated_at).each do |prop|
        expect(project_item_asset).to respond_to(prop.to_sym)
      end
    end

    pending "validation check"

  end

end