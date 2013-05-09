['Lead','Client','Project Manager','Architect','Builder'].each do |r|
  Physical::Project::ProjectRole.create(:name => r)
end

admin = User.create(:username => 'admin', :email => 'admin@example.com', :password => 'password')
admin.add_role :admin 