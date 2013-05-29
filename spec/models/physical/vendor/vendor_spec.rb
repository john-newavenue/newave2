require 'spec_helper'

describe Physical::Vendor::Vendor do

  it "respond to fields" do
    vendor = Physical::Vendor::Vendor.new
    expect(vendor).to respond_to(:name)
    expect(vendor).to respond_to(:slug)
    expect(vendor).to respond_to(:description)
    expect(vendor).to respond_to(:vendor_type)
    expect(vendor).to respond_to(:members)
    expect(vendor).to respond_to(:add_member)
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
    expect(FactoryGirl.create(:vendor, :vendor_type => Physical::Vendor::VendorType.all.sample )).to be_valid
  end

  it "should let me add and retrieve vendor members only and only once" do
    vendor = FactoryGirl.create(:vendor)
    customer_user = FactoryGirl.create(:customer_user)
    vendor_user = FactoryGirl.create(:vendor_user)
    # cannot add someone without a vendor role
    expect(vendor.add_member(customer_user)).to be_nil
    # can add someone with a vendor role
    vendor.add_member(vendor_user)
    expect(vendor.members.to_a.include? vendor_user).to be_true
    # cannot readd the same vendor_user
    expect(vendor.add_member(vendor_user)).to be_nil
  end

end