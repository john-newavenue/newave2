FactoryGirl.define do
  factory :vendor_type, :class => Physical::Vendor::VendorType do |vendor_type|
    sequence(:name) { |n| "Type #{n}" } 
  end

  factory :vendor, :class => Physical::Vendor::Vendor do |vendor|
    sequence(:name) { |n| "Vendor #{n}"}
    association :vendor_type, factory: :vendor_type, strategy: :create
  end

  factory :vendor_member, :class => Physical::Vendor::VendorMember do |vendor_member|
    association :user, factory: :vendor_user, strategy: :create
    association :vendor, factory: :vendor, strategy: :create
  end
end