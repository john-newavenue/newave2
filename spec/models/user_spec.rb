require 'spec_helper'

describe User do 

  before do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:username) }
  # JM 2013-04-30: also should make tests for: password, reset_password_token, etc.

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email is invalid" do
    before { @user.email = "invalid email" }
    it { should_not be_valid }
  end

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when user contains some special characters" do
    before { @user.username = "Crazy-Eight's! Silly 13 & Sons." }
    it { should be_valid }
  end

  ["\\k asd", "!;", "lk a;/", "< >"].each do |invalid_name|
    describe "when user contains some illegal characters" do
      before { @user.username = invalid_name }
      it { should_not be_valid }
    end
  end

end