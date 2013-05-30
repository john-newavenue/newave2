require 'spec_helper'

describe "Asset Model" do

  let(:new_asset) { Physical::Asset::Asset.new() }
  let(:concrete_asset) {
   image_asset = FactoryGirl.create(:image_asset)
   image_asset.asset
 }

  it "shouldn't be directly created" do
    new_asset.valid?
    expect(new_asset).to_not be_valid
  end

  it "a concrete asset has certain properties" do
    expect(concrete_asset).to respond_to(:azzet)
    expect(concrete_asset).to respond_to(:soft_delete)
    expect(concrete_asset).to respond_to(:origin_album_item)
  end

end