require 'spec_helper'

describe "Album Model" do

  let(:album) { FactoryGirl.create(:album, :parent => FactoryGirl.create(:vendor))}

  it "should respond to properties" do
    %w(parent title description deleted_at cover_image).each do |att| 
      expect(album).to respond_to(att.to_sym)
    end
  end

  it "should be soft deleted along with its album items" do
    # create and populate album
    album_to_destroy = FactoryGirl.create(:album, :parent => FactoryGirl.create(:vendor))
    album_to_destroy_items = []
    3.times.each do
      album_to_destroy_items.push(FactoryGirl.create(:album_item, :album => album_to_destroy))
    end
    # soft delete the album and album items
    album_to_destroy.destroy
    expect(Physical::Album::Album.with_deleted.find_by_id(album_to_destroy.id)).to_not be_nil
    expect(Physical::Album::Album.find_by_id(album_to_destroy.id)).to be_nil
    album_to_destroy_items.each do |album_item|
      expect(Physical::Album::AlbumItem.with_deleted.find_by_id(album_item.id)).to_not be_nil
      expect(Physical::Album::AlbumItem.find_by_id(album_item.id)).to be_nil
    end

  end

  it "should accept cover images only from images in album" do
    pending "this"
  end

end