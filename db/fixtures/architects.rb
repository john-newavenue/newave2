require 'debugger'

PROCESS_ATTACHMENTS = true

puts "SEED > architects with PROCESS_ATTACHMENTS = #{PROCESS_ATTACHMENTS}"

users_data = [
  {
    :first_name => "Gary",
    :last_name => "Harcourt",
    :email => "gharcourt@mailinator.com", # constraint
    :username => "gayharcourt",
    :role => :vendor,
    :website_title => "gfh Architecture",
    :website_url => "http://www.gfharchitecture.com/",
    :avatar => nil,
    :is_featured_architect => true,
    :featured_architect_position => 3,
    :bio => """
      In California, I’ve worked on projects up and down the state, from San Diego to Sacramento as well as several states within the continental US. 

      Residentially, I’ve worked on projects ranging from second dwelling units, custom homes, and multi-family residential complexes. My other related work includes condominiums, planned unit developments, subdivisions and parcel splits, independent living, assisted care, senior living communities, and facilities for special needs such as physically handicap, memory care. I have been involved in new projects, remodels, and additions. 
      
      My works have reflected a variety of styles: contemporary/modern, Mediterranean, Spanish, Tuscany, Craftsman, the playfulness of Cotswold, Tudor, California Ranch, and the charm of English Country.  I use an imaginative and creative design process, balancing form and function, and economy and time while going “outside the box” to exhaust all possibilities.   

      Personal interest include: enjoying time with friends and family and the great outdoors with the sport of golf and tennis along with, of course, my love of architecture. I’ve been doing this for more than 30 years and have many friends who started out, like yourselves, as clients.
    """,
    :featured_work_album_images => [
      {
        :title => "Hollister Residential Addition/Remodel",
        :description => "",
        :position => "1",
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/IMG_2909.JPG"),
        :attachment_file_name => "#{Rails.root}/tmp/fixtures/architects/gary_harcourt/IMG_2909.JPG".split('/').last,
        :process_attachment => PROCESS_ATTACHMENTS
      }
    ]

  }
]



users_data.each do |ud| 

  puts "SEED > Processing User #{ud[:email]}"
  User.seed(:email) do |s|
    s.email = ud[:email]
    s.username = ud[:username]
    s.password = "password"
  end

  u = User.find_by(:email => ud[:email])
  # add role
  u.add_role ud[:role] if not u.has_role?(ud[:role])
  # update profile
  p = u.profile
  p.update_attributes!({
    :first_name => ud[:first_name], 
    :last_name => ud[:last_name],
    :is_featured_architect => ud[:is_featured_architect],
    :featured_architect_position => ud[:featured_architect_position],
    :bio => ud[:bio],
    :website_url => ud[:website_url],
    :website_title => ud[:website_title]
  })
  # update album images
  if ud[:featured_work_album_images]
    ud[:featured_work_album_images].each do |img|
      puts "SEED > Processing album image #{img[:title]}"
      Physical::Album::AlbumItem.seed(:album_id, :attachment_file_name) do |s|
        s.album_id = p.featured_work_album_id
        s.title = img[:title]
        s.description = img[:description]
        s.position = img[:position]
        s.attachment_file_name = img[:attachment_file_name]
        s.attachment = img[:attachment] if (PROCESS_ATTACHMENTS and img[:process_attachment])
      end
    end
  end


end