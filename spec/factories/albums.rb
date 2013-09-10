FactoryGirl.define do

  factory :album, :class => Physical::Album::Album do |album|
    association :parent, factory: :vendor, strategy: :create
    sequence(:title) { |n| "Album title #{n}"}
    sequence(:description) { |n| "Album description #{n}"}
  end
  
  factory :album_item, :class => Physical::Album::AlbumItem do |album_item|
    association :album, factory: :album, strategy: :create
    sequence(:title) { |n| "Album Item title #{n}"}
    sequence(:description) { |n| "Album Item description #{n}"}

    factory :album_item_with_image_attachment do |a|
      attachment { fixture_file_upload(Rails.root.join('spec','fixtures', '1000x1000.gif'), 'image/gif') }
    end

    factory :album_item_with_text_attachment do |a|
      attachment { fixture_file_upload(Rails.root.join('spec','fixtures', 'somefile.txt'), 'text/plain') }
    end

  end

  factory :album_item_category, :class => Physical::Album::AlbumItemCategory do |f|
    f.name { Faker::Lorem.word }
  end

end