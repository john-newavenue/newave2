namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    make_users_and_projects
    #make_project_types
  end

  desc "Renew database with sample data"
  task :renew => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['db:populate'].invoke
  end

end

def make_users_and_projects
  # create some more users
  user_client_jane = User.create!(:username => 'Client Jane ', :email => 'jane@example.com', :password => 'password')
  user_client_jane.add_role(:client)
  user_client_john = User.create!(:username => 'Client John', :email => 'john@example.com', :password => 'password')
  user_client_john.add_role(:client)
  user_pm_adam = User.create!(:username => 'PM Adam', :email => 'adam@example.com', :password => 'password')
  user_pm_adam.add_role(:pm)
  user_arch_sylvester = User.create!(:username => 'Architect Sylvester', :email => 'sylvester@example.com', :password => 'password')
  user_pm_adam.add_role(:vendor)
  user_builder_bob = User.create!(:username => 'Builder Bob', :email => 'bob@example.com', :password => 'password')
  user_pm_adam.add_role(:vendor)
  20.times.each { 
    u = User.create(:username => Faker::Name.name, :email => Faker::Internet.email, :password => 'password') 
    u.add_role( [:client, :pm, :vendor].sample )
  }
  

  # make some projects
  proj_jane_adu = Physical::Project::Project.create!(:title => "Jane's ADU", :description => "This is my ADU project.")
  proj_jane_2nd_adu = Physical::Project::Project.create!(:title => "Jane's 2nd ADU", :description => "This is my 2nd ADU project.")
  proj_john_cottage = Physical::Project::Project.create!(:title => "John's Cottage", :description => "This is John's cottage project.")

  # get the kinds of roles
  client_role = Physical::Project::ProjectRole.find_by_name('Client')
  arch_role = Physical::Project::ProjectRole.find_by_name('Architect')
  pm_role = Physical::Project::ProjectRole.find_by_name('Project Manager')
  builder_role = Physical::Project::ProjectRole.find_by_name('Builder')

  # assign some users to projects
  Physical::Project::ProjectMember.create!(:user => user_client_jane, :project_role => client_role, :project => proj_jane_adu)
  Physical::Project::ProjectMember.create!(:user => user_client_jane, :project_role => client_role, :project => proj_jane_2nd_adu)
  Physical::Project::ProjectMember.create!(:user => user_client_john, :project_role => client_role, :project => proj_john_cottage)
  Physical::Project::ProjectMember.create!(:user => user_pm_adam, :project_role => pm_role, :project => proj_jane_adu)
  Physical::Project::ProjectMember.create!(:user => user_pm_adam, :project_role => pm_role, :project => proj_jane_2nd_adu)
  Physical::Project::ProjectMember.create!(:user => user_builder_bob, :project_role => builder_role, :project => proj_jane_adu)


end

def make_project_types
  p = Admin::ProjectType
  p.create!(
    title: 'Addition',
    description: 'Expanding your existing house.'
  )
  p.create!(
    title: 'Remodel',
    description: 'Remodel a part of your home.'
  )
  p.create!(
    title: 'Second Unit',
    description: 'Habitable dwelling with kitchen, bathroom, bedroom.'
  )
  p.create!(
    title: 'Consultation',
    description: 'Just asking for professional recommendations.'
  )
end