FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "password"

    # TODO: DRY this up with seeded vendor types

    factory :client_user do
      after(:create) { |user| 
        user.add_role(:client)
      }
    end

    factory :customer_user do
      after(:create) { |user| 
        user.add_role(:customer)
      }
    end


    factory :project_manager_user do
      after(:create) { |user| 
        user.add_role(:project_manager)
      }
    end

    factory :vendor_user do
      after(:create) { |user| 
        user.add_role(:vendor)
      }
    end

    factory :admin_user do
      after(:create) { |user| 
        user.add_role(:admin)
      }
    end
  end



end