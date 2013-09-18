require 'debugger'

PROCESS_ATTACHMENTS = true

puts "SEED > brochures with PROCESS_ATTACHMENTS = #{PROCESS_ATTACHMENTS}"

cover_images_path = lambda { |filename| "#{Rails.root}/tmp/fixtures/brochures/cover-images/#{filename}" }

brochures_data = [
  {
    :title => "Big L", # constraint
    :slug => "big-l",
    :position => 1,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 680,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Ideal for someone looking for something traditional and beautiful with plenty of indoor and outdoor living space.  This is spacious for one person but can be two bedrooms with two lofts so it really flexes for up to a family of four. ", # ideal for
    :long_description => "One of our more popular plans, the Big L is a great option for a more traditional design with plenty of comfortable living space. Two decks help connect you with the outdoors and the living space is big enough to entertain guests. The loft adds even more room for storage or an office, and the high, open ceilings make it feel even bigger than it is.",
    :teaser_line => "traditional, elegant, roomy",
    :album_id => 17,
    :cover_image => File.new(cover_images_path.call("big-l.jpg")),
    :cover_image_file_name => "big-l.jpg",
    :is_published => true
  },
  {
    :title => "Mansion", # constraint
    :slug => "mansion",
    :position => 2,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 800,
    :number_of_bath => 1,
    :number_of_bed => 2,
    :number_of_stories => 1,
    :has_loft => false,
    :short_description => "There is extra room that allows for wider hallways, kitchen and bigger bathrooms.   This spaciousness is a luxury for anyone and can be a real asset for anyone who wants a level living area for a wheelchair, bad knees or just plain comfort. ", # byline
    :long_description => "One of our more popular plans, the Big L is a great option for a more traditional design with plenty of comfortable living space. Two decks help connect you with the outdoors and the living space is big enough to entertain guests. The loft adds even more room for storage or an office, and the high, open ceilings make it feel even bigger than it is.",
    :teaser_line => "modern, spacious, inviting",
    :album_id => 16,
    :cover_image => File.new(cover_images_path.call("mansion.jpg")),
    :cover_image_file_name => "mansion.jpg",
    :is_published => true
  },
  {
    :title => "Eco House", # constraint
    :slug => "palo-alto-eco-house",
    :position => 3,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 454,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Ideal for a second home or guest house in a natural setting. The bedroom holds a queen sized bed and the loft provides room for occasional guests. ", # byline
    :long_description => "This modern gem brings the outdoors in to your living space with lots of glass and great views. It's small footprint leaves plenty of room for a modern garden and guests.",
    :teaser_line => "simple, sleek, modern",
    :album_id => 24,
    :cover_image => File.new(cover_images_path.call("eco-house.jpg")),
    :cover_image_file_name => "eco-house.jpg",
    :is_published => true
  },
  {
    :title => "Reading", # constraint
    :slug => "reading",
    :position => 4,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 700,
    :number_of_bath => 1,
    :number_of_bed => 2,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "A peaceful retreat for a couple as the bedroom is separated from the living area for peace and quite.  The loft can be accessed via a circular stair and overlooks the open kitchen and living room.", # byline
    :long_description => "A classic look with a modern layout, the Reading accommodates a larger number of people while providing different unique spaces. Decks on each end give guests or children a separate outdoor space from the main bedroom's, and a large loft gives flexible sleeping arrangements.",
    :teaser_line => "smart, balanced, peaceful",
    :album_id => 19,
    :cover_image => File.new(cover_images_path.call("reading.jpg")),
    :cover_image_file_name => "reading.jpg",
    :is_published => true
  },
  {
    :title => "Short Line", # constraint
    :slug => "short-line",
    :position => 5,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 420,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Ideal for a second unit for workspace, guests, or rental opportunity. We've had two firefighters and their baby live in this, but it might be a bit tight for most people to really live in.   Ladders are best reserved for children and firefighters. ", # byline
    :long_description => "With it's small footprint and traditional design, the Short Line is a perfect addition to a backyard or a garage conversion. It fits in many different types of spaces and can closely match the look of an existing home. ",
    :teaser_line => "flexible, simple, traditional",
    :album_id => 20,
    :cover_image => File.new(cover_images_path.call("short-line.jpg")),
    :cover_image_file_name => "short-line.jpg",
    :is_published => true
  },
  {
    :title => "Small L", # constraint
    :slug => "small-l",
    :position => 6,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 396,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "An optimal one bedroom that works for downsizing or as a rental opportunity.", # byline
    :long_description => "A smaller version of our Big L, the Small L looks great from the outside and maximizes it's small footpring on the inside. A loft opens things up and the living space has a wonderful feel.",
    :teaser_line => "friendly, inviting, smart",
    :album_id => 18,
    :cover_image => File.new(cover_images_path.call("small-l.jpg")),
    :cover_image_file_name => "small-l.jpg",
    :is_published => true
  },
  {
    :title => "Green Mod Large", # constraint
    :slug => "green-mod-large",
    :position => 7,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 750,
    :number_of_bath => 2,
    :number_of_bed => 2,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Ideal for a second home for a family or entertainer. If you consider the loft areas you have almost 800 square feet and two upstairs sleeping/work areas. ", # byline
    :long_description => "Our Large Green Mod is a wonderfully designed contemporary home that can fit larger groups with room to spare. A open communal feeling is perfect for families or entertaining guests as everyone shares the light, open space.",
    :teaser_line => "modern, sleek, open",
    :album_id => 22,
    :cover_image => File.new(cover_images_path.call("green-mod-large.jpg")),
    :cover_image_file_name => "green-mod-large.jpg",
    :is_published => true
  },
  {
    :title => "Green Mod", # constraint
    :slug => "green-mod",
    :position => 8,
    :category => "Floor Plan", # "Floor Plan" or "Client"
    :area => 400,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Ideal for a modern second home with a very open feel.  With all this glass your eyes can look out towards a garden or view to make it feel bigger.  It's small for a couple but could work for a minimalist looking for a clutter free life. ", # byline
    :long_description => "The Green Mod offers a uniquely contemporary design with a very open feel. Large windows and high ceilings make its small footprint feel much larger and very comfortable.",
    :teaser_line => "open, bold, modern",
    :album_id => 21,
    :cover_image => File.new(cover_images_path.call("green-mod.jpg")),
    :cover_image_file_name => "green-mod.jpg",
    :is_published => true
  },
]

brochures_data.each do |br|
  puts "SEED > Processing Brochure #{br[:title]}"
  Physical::General::Brochure.seed(:title) do |s|
    s.title = br[:title]
    s.slug = br[:slug]
    s.position = br[:position]
    s.category = br[:category]
    s.area = br[:area]
    s.number_of_bath = br[:number_of_bath]
    s.number_of_bed = br[:number_of_bed]
    s.number_of_stories = br[:number_of_stories]
    s.has_loft = br[:has_loft]
    s.short_description = br[:short_description]
    s.long_description = br[:long_description]
    s.teaser_line = br[:teaser_line]
    s.album_id = br[:album_id]
    s.cover_image = br[:cover_image]
    s.is_published = br[:is_published]
  end

end