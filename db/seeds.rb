['Customer','Project Manager','Vendor'].each do |r|
  Physical::Project::ProjectRole.find_or_create_by :name => r
end

['General Contractor','Design-Build', 'Architect', 'Landscape'].each do |r|
  Physical::Vendor::VendorType.find_or_create_by :name => r
end

admin = User.find_or_create_by :username => 'admin'
admin.update_attributes!(:email => 'admin@example.com', :password => 'password')
admin.add_role :admin 