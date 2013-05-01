require 'spec_helper'

describe Physical::Project::ProjectRole do 

  before do
    @project_role = Physical::Project::ProjectRole.new(:name => "Sample Role")
  end

  subject { @project_role }

  it { should respond_to(:name) }

  describe "when role name is not present" do
    before { @project_role.name = " " }
    it { should_not be_valid }
  end

  describe "when role name is already taken" do
    before { @project_role.dup.save }
    it { should_not be_valid }
  end

end