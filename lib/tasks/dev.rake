namespace :db do
  desc "Fill database with sample data"
  task :populate, :environment do
    make_users
    make_project_types
  end

  desc "Renew database with sample data"
  task :renew, :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:populate'].invoke
  end

end

def make_users
  admin = User.create!(
    username: 'admin',
    email: 'admin@example.com',
    password: 'password'
  )
  [:admin, :editor].each { |r| admin.add_role(r) }

  editor = User.create!(
    username: 'editor',
    email: 'editor@example.com',
    password: 'password'
  )

  editor.add_role :editor
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