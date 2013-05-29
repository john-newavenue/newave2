['Customer','Project Manager','Vendor'].each do |r|
  Physical::Project::ProjectRole.find_or_create_by_name(:name => r)
end

['General Contractor','Design-Build', 'Architects & Designers', 'Landscape Architects & Designers'].each do |r|
  Physical::Vendor::VendorType.find_or_create_by_name(:name => r)
end

admin = User.find_or_create_by_username(:username => 'admin', :email => 'admin@example.com', :password => 'password')
admin.add_role :admin 