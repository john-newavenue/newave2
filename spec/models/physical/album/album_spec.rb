require 'spec_helper'

describe "Album Model" do

  let(:album) { FactoryGirl.create(:album, :parent => FactoryGirl.create(:vendor))}

  it "should respond to properties" do
    %w(parent title description deleted_at cover_image).each do |att| 
      expect(album).to respond_to(att.to_sym)
    end
  end

  it "should be soft deleted" do
    album.destroy
    expect(Physical::Album::Album.with_deleted.find_by_id(album.id)).to_not be_nil
    expect(Physical::Album::Album.find_by_id(album.id)).to be_nil
  end

  it "should accept cover images only from images in album" do
    pending "this"
  end

end