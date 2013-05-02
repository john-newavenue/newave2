require 'spec_helper'

describe Physical::Project::ProjectType do 

  before do
    @project_type = Physical::Project::ProjectType.new(:title => "Sample Project Type")
  end

  subject { @project_type }

  it { should respond_to(:title) }
  it { should respond_to(:description) }

  describe "when title is not present" do
    before { @project_type.title = " " }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @project_type.description = " " }
    it { should_not be_valid }
  end

  describe "when project type is already taken" do
    before { @project_type.dup.save }
    it { should_not be_valid }
  end

end