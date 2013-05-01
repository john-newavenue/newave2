FactoryGirl.define do
  factory :user, :class => Physical::User::User do
    sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "password"
  end

  factory :admin do
    after(:create) { |user| 
      [:admin,:editor].each { |role| user.add_role(role) }
    }
  end


end