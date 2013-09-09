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

  factory :brochure, :class => Physical::General::Brochure do |f|
    f.title { Faker::Company.name }
    f.slug { title.parameterize }
    f.area { rand(400..700) }
    f.number_of_bed { rand(1..4) }
    f.number_of_bath { rand(1..2) }
    f.short_description { Faker::Lorem.sentence(50) }
    f.long_description { Faker::Lorem.sentence(150) }
    # album/album_id should be populated with a model callback
    factory :brochure_floorplan do |b|
      b.category "Floor Plan"
    end
    factory :brochure_client do |b|
      b.category "Client"
    end
  end

end