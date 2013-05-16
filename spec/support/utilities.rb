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

def quick_check_1(user, method, action, code)
  # user   : user instance
  # method : string such as "get", "post"
  # action : symbol such as :new, :index
  # code   : HTTP code integer such as 200, 404
  
  sign_in user
  eval("#{method} :#{action.to_sym}") # evaluates something like "get :index"
  return expect(response.code).to eq(code.to_s)
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert-box.alert', text: message)
  end
end