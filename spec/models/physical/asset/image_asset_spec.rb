require 'spec_helper'

describe "Image Asset Model" do

  let(:image_asset) { FactoryGirl.create(:image_asset) }

  it "responds to properties" do
    %w(asset image image_file_name image_file_size image_content_type image_updated_at).each do |attr|
      expect(image_asset).to respond_to(attr.to_sym)
    end
  end

  it "creates sizes" do
    %w(small_square medium_square large_square small medium large).each do |size|
      expect(image_asset.image(size.to_sym)).to_not be_blank
    end
  end

  it "accepts only images of < 5 MB", :slow => true do
    image_asset = FactoryGirl.build(:image_asset, :image => fixture_file_upload('large_file.txt') )
    image_asset.valid?
    expect(image_asset).to_not have(:no).errors_on(:image_content_type)
    expect(image_asset).to_not have(:no).errors_on(:image_file_size)
  end

  it "avoids processing erroneous images" do
    image_asset = FactoryGirl.build(:image_asset, :image => fixture_file_upload('fake_image.jpg'))
    image_asset.valid?
    expect(image_asset).to_not have(:no).errors_on(:image_content_type)
  end



end