require 'spec_helper'

describe Physical::Vendor::VendorMember do

  it "should respond to certain fields" do
    vendor_member = FactoryGirl.create(:vendor_member)
    expect(vendor_member).to respond_to(:user)
    expect(vendor_member).to respond_to(:vendor)
  end

  it "fails with invalid user" do
    vendor_member = FactoryGirl.create(:vendor_member)
    vendor_member.user = nil
    expect(vendor_member.valid?).to be_false
    vendor_member.user_id = -1
    expect(vendor_member.valid?).to be_false
  end

  it "fails with no/invalid vendor" do
    vendor_member = FactoryGirl.create(:vendor_member)
    vendor_member.vendor = nil
    expect(vendor_member.valid?).to be_false
    vendor_member.vendor_id = -1
    expect(vendor_member.valid?).to be_false
  end

  it "passes with valid user and vendor" do
    # this test is kind of pointless as FactoryGirl creates a valid instance
    vendor_member = FactoryGirl.create(:vendor_member)
    expect(vendor_member).to be_valid
  end

end