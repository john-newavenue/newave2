require 'debugger'

PROCESS_ATTACHMENTS = true

puts "SEED > architects with PROCESS_ATTACHMENTS = #{PROCESS_ATTACHMENTS}"

users_data = [

  {
    :first_name => "Guy",
    :last_name => "Lubroth",
    :email => "glubroth@mailinator.com", # constraint
    :username => "guylubroth",
    :slug => "guylubroth".parameterize,
    :role => :vendor,
    :website_title => "Guy Lubroth Architect",
    :website_url => "http://www.guylubrotharchitect.com/",
    :avatar => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/guy-lubroth-placeholder.png"),
    :is_featured_architect => true,
    :featured_architect_position => 2,
    :bio => """
      I enjoy collaborating with clients to explore and visualize the possibilities to resolve their needs and desires. I am comfortable with both traditional and contemporary design and have worked on interesting, creative, and unique projects on houses in the East Bay and surrounding areas such as Napa, as well as Costa Rica, Rome, and Spain. I like backyard cottages so much, I even designed one for my own backyard.

      I grew up in Madrid, Spain and attended college at the Rhode Island School of Design. I practiced architecture in the NYC area with a variety of offices, focusing on multi-family, high-end residential and art galleries, and then moved to the Bay area and worked in a variety of offices doing multi-family, live/work lofts, high-end residential, and restaurants.

      In 1992 I started my own practice doing high-end residences, additions, and remodels, and received an \"Excellence In Residential Design\" award for a house I designed in Oakland after the fire from the AIA.
    """,
    :featured_work_album_images => [
      {
        :title => "Grand View Bedroom",
        :description => "Grand View Bedroom",
        :position => 10,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/1707 Grand View 06.jpg"),
        :process_attachment => true
      },
      {
        :title => "Grand View Kitchen",
        :description => "Grand View Kitchen",
        :position => 20,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/1707 Grand View 14.jpg"),
        :process_attachment => true
      },
      {
        :title => "Bathroom",
        :description => "Bathroom",
        :position => 30,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/Bath 1.jpg"),
        :process_attachment => true
      },
      {
        :title => "Bathroom Cabinet",
        :description => "Bathroom Cabinet",
        :position => 40,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/BathBcabinetB.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Yard and Exterior",
        :description => "Yard and Exterior",
        :position => 50,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/DSCN3127.JPG"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Kitchen",
        :description => "Kitchen",
        :position => 60,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/DSCN3488.JPG"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Bathroom Sink",
        :description => "Bathroom Sink",
        :position => 70,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/DSCN3654.JPG"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Skylights",
        :description => "Skylights",
        :position => 80,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/DSCN4270.JPG"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Deck",
        :description => "Deck",
        :position => 90,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/DSCN4744.JPG"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Dining",
        :description => "Dining",
        :position => 100,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/DSCN6189.JPG"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Living",
        :description => "Living",
        :position => 110,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/imag_63_VQ0U5T.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Office",
        :description => "Office",
        :position => 120,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/guy_lubroth/Office.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
    ]
  },
  {
    :first_name => "Bill",
    :last_name => "Luza",
    :email => "billluza@mailinator.com", # constraint
    :username => "bill-luza",
    :slug => "bill-luza".parameterize,
    :role => :vendor,
    :website_title => "objet design",
    :website_url => "http://www.objetdesign.com/",
    :avatar => File.new("#{Rails.root}/tmp/fixtures/architects/bill_luza/bill_luza.jpg"),
    :is_featured_architect => true,
    :featured_architect_position => 3,
    :bio => """
Bill is a graduate of the North Carolina State University - School of Design, with a BEDA degree in Environmental Design/Architecture, and has over 21 years of design and project management experience. He has been an invited Guest Lecturer and Critic for design and architecture courses and studios at Pratt Institute, Virginia Technical Institute, The Corcoran College of Art and Design, The Catholic University of America, North Carolina State University, and De Montfort University (Leicester, UK); and the students at these schools have periodically been given assignments based on objet's design studies.

In late 2006 through 2007, Bill took a 9 month research sabbatical, traveling through the UK, Germany,Austria, Italy, and France, on a quest to explore food-services culture and systems-built affordable housing.

In 2007, Bill returned to the US, and since then the objet team has been at it - designing and prototyping new food and beverage concepts, and working on prototypes for the more affordable Affordable-Home.

On the food-services side, Bill has a particular interest in the design of grocery stores, cafés, and the 'third-place'. He has done prototype design work for Whole Foods Grocery Stores, Red Box Automated Convenience Stores (McDonald's Corp), fine dining establishments, cafés and bars; and in 2008 was selected by Starbucks and Shop24 as a preferred Designer/Project Manager to someday possibly assist each company with proposed rebranding and development.

On the housing side, Bill and objet design have been working towards designing better looking, smarter, more accessible, affordable, and sustainable modern-housing. Our residential clients have good ideas and a quest for better living, but they're typically short of the all-mighty-dollars necessary to renovate or new-build a home. In light of this, we've taken it upon ourselves to challenge and rethink the design and construction of the roof over our heads.
    """,
    :featured_work_album_images => [
      {
        :title => "Built",
        :description => "Built",
        :position => 10,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/bill_luza/Built.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Field",
        :description => "Field",
        :position => 20,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/bill_luza/Field.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Rendering",
        :description => "Rendering",
        :position => 30,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/bill_luza/Rendering.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Stairs",
        :description => "Stairs",
        :position => 40,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/bill_luza/Stairs.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Thumbprint House",
        :description => "Thumbprint House",
        :position => 50,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/bill_luza/Thumbprint House.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      }
    ]
  },
  {
    :first_name => "Gary",
    :last_name => "Harcourt",
    :email => "garyharcourt@mailinator.com", # constraint
    :username => "garyharcourt",
    :slug => "garyharcourt".parameterize,
    :role => :vendor,
    :website_title => "gfh Architecture",
    :website_url => "http://www.gfharchitecture.com/",
    :avatar => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/gary2.jpg"),
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
        :title => "Terry Residence",
        :description => "Terry Residence",
        :position => 10,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/terry-residence-a.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Terry Residence",
        :description => "Terry Residence",
        :position => 20,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/terry-residence-b.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Hollstein Residential Addition/Remodel",
        :description => "Hollstein Residential Addition/Remodel",
        :position => 30,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/hollstein-a.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Hollstein Residential Addition/Remodel",
        :description => "Hollstein Residential Addition/Remodel",
        :position => 40,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/hollstein-b.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Hollstein Residential Addition/Remodel",
        :description => "Hollstein Residential Addition/Remodel",
        :position => 50,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/hollstein-c.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Lawrie Residence",
        :description => "Lawrie Residence",
        :position => 60,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/lawrie-residence-a.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Musacco Beach House",
        :description => "Musacco Beach House",
        :position => 70,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/musacco-a.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
      {
        :title => "Musacco Beach House",
        :description => "Musacco Beach House",
        :position => 80,
        :attachment => File.new("#{Rails.root}/tmp/fixtures/architects/gary_harcourt/musacco-b.jpg"),
        :process_attachment => PROCESS_ATTACHMENTS
      },
    ]
  },

]



users_data.each do |ud| 

  puts "SEED > Processing User #{ud[:email]}"
  User.seed(:email) do |s|
    s.email = ud[:email]
    s.username = ud[:username]
    s.slug = ud[:slug]
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
    :website_title => ud[:website_title],
    :avatar => ud[:avatar]
  })
  # update album images
  if ud[:featured_work_album_images]
    ud[:featured_work_album_images].each do |img|
      puts "SEED > Processing album image #{img[:title]}"
      success = false
      while not success
        begin
          puts "SEED > Trying at #{Time.now}"
          Physical::Album::AlbumItem.seed(:album_id, :attachment_file_name) do |s|
            s.album_id = p.featured_work_album_id
            s.title = img[:title]
            s.description = img[:description]
            s.position = img[:position]
            s.attachment_file_name = img[:attachment].path.split('/').last
            s.attachment = img[:attachment] if (PROCESS_ATTACHMENTS or img[:process_attachment])
          end
          success = true
        rescue => error
          puts "Error... let's try again"
          success = false
        end
      end
    end
  end


end