include ApplicationHelper

def sign_in(user)
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Sign in"
end

def sign_out
  click_on 'Sign Out' if page.has_content? 'Sign Out'
end


RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert-box.alert', text: message)
  end
end