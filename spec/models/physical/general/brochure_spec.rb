require 'spec_helper'

describe "Brochrue Spec" do

  it "should automatically have an album upon creation" do
    brochure = FactoryGirl.create(:brochure_floorplan)
    expect(brochure.album).to_not be_nil
  end

end