FactoryGirl.define do
  # factory :project do
  #   sequence(:title)  { |n| "Project #{n}" }
  #   sequence(:description) { |n| "this is project #{n}"}   
  # end

  factory :project, :class => Physical::Project::Project do |project|
    sequence(:title) { |n| "Project #{n}" }
    sequence(:description) { |n| "This is a description for Project #{n}" }
  end

  factory :project_item, :class => Physical::Project::ProjectItem do |project_item|
    sequence(:body) { |n| "Project item body! #{n}"}
    association :project, factory: :project, strategy: :create
  end

end