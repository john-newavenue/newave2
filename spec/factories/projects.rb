FactoryGirl.define do
  # factory :project do
  #   sequence(:title)  { |n| "Project #{n}" }
  #   sequence(:description) { |n| "this is project #{n}"}   
  # end

  factory :project, :class => Physical::Project::Project do |project|
    sequence(:title) { |n| "Project #{n}" }
    sequence(:description) { |n| "This is a description for Project #{n}" }
  end

end