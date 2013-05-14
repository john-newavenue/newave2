FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "password"


    factory :client do
      after(:create) { |user| 
        user.add_role(:client)
      }
    end

    factory :customer do
      after(:create) { |user| 
        user.add_role(:customer)
      }
    end


    factory :admin do
      after(:create) { |user| 
        user.add_role(:admin)
      }
    end
  end



end