require 'spec_helper'

describe "Album Item Model" do

  let(:album_item) { FactoryGirl.create(:album_item )}

  it "should respond to properties" do
    %w(album title description deleted_at).each do |att| 
      expect(album_item).to respond_to(att.to_sym)
    end
  end

  it "should be soft deleted" do
    album_item.destroy
    expect(Physical::Album::AlbumItem.with_deleted.find_by_id(album_item.id)).to_not be_nil
    expect(Physical::Album::AlbumItem.find_by_id(album_item.id)).to be_nil
  end

end