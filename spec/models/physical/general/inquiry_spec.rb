require 'spec_helper'

describe "Inquiry model" do

  it "responds to certain fields" do
    inquiry = Physical::General::Inquiry.new
    %w(category user first_name last_name phone_number email message referral).each do |attr|
      expect(inquiry).to respond_to(attr.to_sym)
    end
  end

  it "validates certain fields" do
    inquiry = Physical::General::Inquiry.new
    inquiry.category = "invalid_category"
    inquiry.valid?
    # required
    expect(inquiry).to_not have(:no).errors_on(:category)
    expect(inquiry).to_not have(:no).errors_on(:first_name)
    expect(inquiry).to_not have(:no).errors_on(:last_name)
    expect(inquiry).to_not have(:no).errors_on(:email)
    expect(inquiry).to_not have(:no).errors_on(:message)
    # optional
    expect(inquiry).to have(:no).errors_on(:submitted_form_url)
    expect(inquiry).to have(:no).errors_on(:user)
    expect(inquiry).to have(:no).errors_on(:phone_number)
    expect(inquiry).to have(:no).errors_on(:referral)
    # fresh inquiry with default category
    inquiry = Physical::General::Inquiry.new
    inquiry.user_id = -1
    inquiry.email = "invalid_email"
    inquiry.valid?
    expect(inquiry.user).to be_nil
    expect(inquiry).to_not have(:no).errors_on(:email)
    inquiry.user = FactoryGirl.create(:customer_user)
    inquiry.email = "valid@email.com"
    inquiry.valid?
    expect(inquiry).to have(:no).errors_on(:user)
    expect(inquiry).to have(:no).errors_on(:email)

  end

  it "can compose message" do
    # contact form just spits out fields
    inquiry = Physical::General::Inquiry.new(
      :first_name => "Jon",
      :last_name => "Snow",
      :message => "I want a new house.",
      :email => "jon@snow.com",
      :category => "contact_form"
    )
    expect(inquiry).to be_valid
    expect(inquiry.compose_message).to include("I want a new house.")

    # mad lib form has a different message format
    inquiry = Physical::General::Inquiry.new(
      :first_name => "Jon",
      :last_name => "Snow",
      :phone_number => "123-456-7890",
      :email => "jon@snow.com",
      :category => "mad_lib_form",
    )
    expect(inquiry).to be_valid
    expect(inquiry.compose_message).to include("My name is Jon Snow.", "My phone number is 123-456-7890")
  end

  pending "Can send to zoho"
  pending "Can send to staff"

end