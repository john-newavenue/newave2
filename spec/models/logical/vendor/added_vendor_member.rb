require 'spec_helper'

describe Logical::Vendor::AddedVendorMember do

  describe "permitted additions to a vendor" do

    let!(:vendor) { FactoryGirl.create(:vendor) }
    let!(:other_vendor) { FactoryGirl.create(:vendor) }
    let!(:vendor_user) { FactoryGirl.create(:vendor_user) }
    let!(:customer_user) { FactoryGirl.create(:customer_user) }
    let(:added_vendor_member) {Logical::Vendor::AddedVendorMember.new() }


    it "should verify user and vendor exist" do
      added_vendor_member.update_attributes(:vendor_id => -1, :username => "FFFFFFFFFFFFF")
      added_vendor_member.valid?
      expect(added_vendor_member).to have_at_least(1).error_on(:username)
      expect(added_vendor_member).to have_at_least(1).error_on(:vendor_id)
    end

    it "not let non-vendor users be added" do
      added_vendor_member.update_attributes(:vendor_id => vendor.id, :username => customer_user.username)
      added_vendor_member.valid?
      expect(added_vendor_member).to have_at_least(1).error_on(:username)
    end

    it "not let vendor members be added to multiple vendors" do
      other_vendor.add_member(vendor_user)
      added_vendor_member.update_attributes(:vendor_id => vendor.id, :username => customer_user.username)
      added_vendor_member.valid?
      expect(added_vendor_member).to have_at_least(1).error_on(:username)
    end

  end

end