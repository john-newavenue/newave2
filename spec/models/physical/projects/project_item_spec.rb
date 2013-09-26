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

    describe "behavior between timeline activity and album item" do

      it "should be destroyed if associated album item is destroyed" do
        project = FactoryGirl.create(:project)
        album_item = FactoryGirl.create(:album_item_with_image_attachment, :album => project.primary_album)
        project_item = project.items.order('id DESC').first
        expect(project_item.project_item_assets.map(&:album_item_id)).to include(album_item.id)
        project_item.update_attributes!(:deleted_at => Time.now)
        album_item.reload
        expect(album_item.deleted_at).to_not be_nil
      end

      it "should destroy associated album item if activity is destroyed" do
        project = FactoryGirl.create(:project)
        album_item = FactoryGirl.create(:album_item_with_image_attachment, :album => project.primary_album)
        project_item = project.items.order('id DESC').first
        expect(project_item.project_item_assets.map(&:album_item_id)).to include(album_item.id)
        album_item.update_attributes!(:deleted_at => Time.now)
        project_item.reload
        expect(project_item.deleted_at).to_not be_nil
      end

    end

  end

end