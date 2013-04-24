FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
  end

  factory :admin do
    after(:create) { |user| 
      [:admin,:editor].each { |role| user.add_role(role) }
    }
  end


end