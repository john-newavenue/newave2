require 'spec_helper'

describe "Admin - Project Types" do

  subject { page }

  describe "index" do
    before { visit root_path }
    it { should have_title('Project Types Admin') }
  end


end