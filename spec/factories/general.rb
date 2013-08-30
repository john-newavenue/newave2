FactoryGirl.define do
  
  factory :inquiry, :class => Physical::General::Inquiry do |f|
    f.submitted_from_url { "/some/random/place" }
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { Faker::Internet.email }
    f.message { Faker::Lorem.sentence }
    
    factory :invalid_inquiry do |g|
      g.email { nil }
    end

  end

end