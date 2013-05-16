require 'spec_helper'

describe Physical::Vendor::Vendor do

  it "respond to fields" do
    vendor = Physical::Vendor::Vendor.new
    expect(vendor).to respond_to(:name)
    expect(vendor).to respond_to(:slug)
    expect(vendor).to respond_to(:description)
    expect(vendor).to respond_to(:vendor_type)
  end

  it "fails with no name/slug" do
    #expect(Physical::Vendor::Vendor.new).to have(1).error_on(:name)
    expect(FactoryGirl.build(:vendor, :name => " ")).to have_at_least(1).error_on(:name)
    expect(FactoryGirl.build(:vendor, :name => " ")).to have_at_least(1).error_on(:slug)
  end

  it "should populate slug" do
    vendor = FactoryGirl.create(:vendor, :name => "A Cool Vendor")
    expect(vendor.slug).to eq('a-cool-vendor')
  end

  it "fails with invalid vendor type" do
    expect(FactoryGirl.build(:vendor, :vendor_type => nil)).to have_at_least(1).error_on(:vendor_type)
    expect(FactoryGirl.build(:vendor, :vendor_type_id => -1)).to have_at_least(1).error_on(:vendor_type)
  end

  it "passes with a valid vendor type" do
    expect(FactoryGirl.create(:vendor, :vendor_type => FactoryGirl.create(:vendor_type))).to be_valid
  end

end