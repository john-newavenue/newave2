require 'spec_helper'

describe Physical::Vendor::VendorType do

  it "should respond to certain fields" do
    vendor_type = Physical::Vendor::VendorType.new
    expect(vendor_type).to respond_to(:name)
    expect(vendor_type).to respond_to(:slug)
    expect(vendor_type).to respond_to(:description)
  end

  it "fails with invalid name/slug" do
    expect(Physical::Vendor::VendorType.new).to have(1).error_on(:name)
    expect(Physical::Vendor::VendorType.new).to have(1).error_on(:slug)
  end

  it "should populate slug" do
    vendor_type = Physical::Vendor::VendorType.create!(:name => 'Vendor Type 1')
    expect(vendor_type.slug).to eq('vendor-type-1')
  end

end
