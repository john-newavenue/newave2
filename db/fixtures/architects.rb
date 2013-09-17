users_data = [
  {
    :first_name => "Gary",
    :last_name => "Harcourt",
    :email => "garyharcourt_seed@email.com",
    :username => "gharcourt",
    :role => :vendor,
    :website_title => "",
    :website_url => "",
    :avatar => nil,
    :is_featured_architect => true,
    :featured_architect_position => 3,
    :bio => """
      This is Gary's bio.
    """

  }
]

users_data.each do |ud| 

  User.seed(:username, :email) do |s|
    s.email = ud[:email]
    s.username = ud[:username]
    s.password = "password"
  end

  u = User.find_by(:email => ud[:email])
  u.add_role ud[:role]
  p = u.profile
  p.update_attributes!({
    :first_name => ud[:first_name], 
    :last_name => ud[:last_name],
    :is_featured_architect => ud[:is_featured_architect],
    :featured_architect_position => ud[:featured_architect_position]
  })

end