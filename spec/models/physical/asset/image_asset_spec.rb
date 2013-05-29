require 'spec_helper'

describe "Image Asset" do

  it "responds to certain properties" do
    image_asset = Physical::Asset::ImageAsset.new
    expect(image_asset).to respond_to(:asset)
  end

end