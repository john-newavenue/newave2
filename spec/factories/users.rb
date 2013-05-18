FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "password"

    [:client_user, :customer_user, :project_manager_user, :vendor_user, :admin_user].each do |user_type|
      factory user_type do
        after(:create) do |user|
          user.add_role(/(.+)_user$/.match(user_type).to_a.last.to_sym ) 
        end
      end
    end

  end

end