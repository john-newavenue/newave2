FactoryGirl.define do

  factory :album, :class => Physical::Album::Album do |album|
    sequence(:title) { |n| "Album title #{n}"}
    sequence(:description) { |n| "Album description #{n}"}
  end
  
  factory :album_item, :class => Physical::Album::AlbumItem do |album_item|
    association :album, factory: :album, strategy: :create
    sequence(:title) { |n| "Album Item title #{n}"}
    sequence(:description) { |n| "Album Item description #{n}"}
  end

  
 


end