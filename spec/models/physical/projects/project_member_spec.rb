require 'spec_helper'

describe Physical::Project::ProjectMember do 

  let(:user) { FactoryGirl.create(:user) }
  let(:client_role) { Physical::Project::ProjectRole::CLIENT }
  let(:project) { FactoryGirl.create(:project) }
  before do
    @project_member = Physical::Project::ProjectMember.new(
      :project_role => client_role,
      :project => project,
      :user => user
    )
  end

  subject { @project_member }

  it { should respond_to(:project_role) }
  it { should respond_to(:project) }
  it { should respond_to(:user) }

  describe "when role is not present" do
    before { @project_member.project_role = nil }
    it { should_not be_valid }
  end

  describe "when project is not present" do
    before { @project_member.project = nil }
    it { should_not be_valid }
  end

  describe "when user is not present" do
    before { @project_member.user = nil }
    it { should_not be_valid }
  end

end