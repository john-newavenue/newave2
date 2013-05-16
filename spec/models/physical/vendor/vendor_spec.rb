require 'spec_helper'

describe Physical::Vendor::Vendor do

  it "respond to fields" do
    vendor = Physical::Vendor::Vendor.new
    expect(vendor).to respond_to(:name)
    expect(vendor).to respond_to(:slug)
    expect(vendor).to respond_to(:description)
    expect(vendor).to respond_to(:vendor_type)
  end

  it "fails with no name" do
    expect(Physical::Vendor::Vendor.new).to have(1).error_on(:name)
  end

  it "fails with no slug" do
    expect(Physical::Vendor::Vendor.new).to have(1).error_on(:slug)
  end

  it "should populate slug" do
    vendor = FactoryGirl.create(:vendor, :name => "A Cool Vendor")
    expect(vendor.slug).to eq('a-cool-vendor')
  end

  it "fails with invalid vendor type" do
    expect { Physical::Vendor::Vendor.create!(:name => 'Someone') }.to raise_error(ActiveRecord::RecordInvalid)
    expect { Physical::Vendor::Vendor.create!(:name => 'Someone', :vendor_type_id => 999 ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  # it "passes with a valid vendor type" do
  #   5.times { FactoryGirl.create(:vendor_type) }
  #   vendor = Physical::Vendor::Vendor.create!( :name => 'Vendor 1',:vendor_type => Physical::Vendor::VendorType.all.sample )
  #   expect(vendor).to have(0).error_on(:vendor_type)
  # end

end