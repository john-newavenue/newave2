# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


['Client','Project Manager','Architect','Builder'].each do |r|
  Physical::Project::ProjectRole.create(:name => r)
end

admin = User.create(:username => 'admin', :email => 'admin@example.com', :password => 'password')
admin.add_role :admin 