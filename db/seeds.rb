['Lead','Client','Project Manager','Vendor'].each do |r|
  Physical::Project::ProjectRole.create(:name => r)
end

['General Contractor','Design-Build', 'Architects & Designers', 'Landscape Architects & Designers'].each do |r|
  Physical::Vendor::VendorType.create(:name => r)
end

admin = User.create(:username => 'admin', :email => 'admin@example.com', :password => 'password')
admin.add_role :admin 