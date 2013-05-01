require 'spec_helper'

describe Physical::Project::Project do 

  before do
    @project = Physical::Project::Project.new(:title => "Sample Project")
  end

  subject { @project }

  it { should respond_to(:title) }
  it { should respond_to(:description) }

  describe "when title is not present" do
    before { @project.title = " " }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @project.description = " " }
    it { should_not be_valid }
  end

end