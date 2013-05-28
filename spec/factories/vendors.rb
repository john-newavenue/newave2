FactoryGirl.define do
  
  factory :vendor, :class => Physical::Vendor::Vendor do |vendor|
    sequence(:name) { |n| "Vendor #{n}"}
    vendor_type Physical::Vendor::VendorType.all.sample
  end

  factory :vendor_member, :class => Physical::Vendor::VendorMember do |vendor_member|
    association :user, factory: :vendor_user, strategy: :create
    association :vendor, factory: :vendor, strategy: :create
  end
end