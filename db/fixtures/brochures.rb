require 'debugger'

PROCESS_ATTACHMENTS = true
PROCESS_CATEGORY = ["Client"] # options: ["Client", "Floor Plan"]

puts "SEED > brochures with PROCESS_ATTACHMENTS = #{PROCESS_ATTACHMENTS}"

cover_images_path = lambda { |filename| "#{Rails.root}/tmp/fixtures/brochures/cover-images/#{filename}" }

brochures_data = [

 #
 # Floor Plans
 #

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
    :short_description => "There is extra room that allows for wider hallways, kitchen and bigger bathrooms.   This spaciousness is a luxury for anyone and can be a real asset for anyone who wants a level living area for a wheelchair, bad knees or just plain comfort. ", 
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
    :short_description => <<EOS

        <p>Ideal for a second home or guest house in a natural setting. The bedroom holds a queen sized bed and the loft provides room for occasional guests. </p>

    EOS,
    :long_description => <<EOS

        <p>New Avenue partnered with The US Department of Energy, The City of San Jose and The City of Palo Alto, to create this modular home as a model of sustainability and energy efficiency. The DOE funded the initial display in San Jose.</p>
        <p>The small home has a full kitchen, bathroom, laundry, one bedroom and an extra sleeping loft.</p>
        <p>The home is fully wheelchair accessible and incorporates sustainable products from all of the companies below. Most notably, this includes bamboo floors, salvaged windows, Trex decking, Mythic non-toxic paints, recycled glass counters, recycled glass tiles, an efficient mini split heat pump for heating and cooling, solar panels a metal roof and rain barrels.</p>
        <p>More than This home is open to the public through April 2013. Contact the City of Palo Alto here: click here to schedule a visit.</p>
        <p>As a a modular home it was built under factory conditions and was inspected and permitted by the state of California. It can be set on any property or in any backyard in the state. At the end of the Palo Alto exhibit we will sell the home. Contact us if you are interested in purchasing the home. New Avenue can manage your local permitting, utilities and foundation work as needed.</p>

        <ul>
        <li><a href="http://www.newavenuehomes.com" target="_blank">New Avenue, Inc.</a> - Design, Financing, and Construction</li>
        <li><a href="http://www.bakermarble.com" target="_blank">Baker Marble +Granite</a> - Counter Fabrication and Installation</li>
        <li><a href="http://www.ocisf.com" target="_blank">Ogden Contract Interiors</a> - Bamboo Flooring Installation</li>
        <li><a href="http://www.velux.com" target="_blank">Velux</a> - Skylights and Sun Tunnels</li>
        <li><a href="http://www.jeld-wen target="_blank".com">Jeld Wen</a> - Windows and Doors</li>
        <li><a href="http://us.sanyo.com target="_blank"/hvac">Sanyo</a> - Mini-Split Heat and A/C</li>
        <li><a href="http://www.panasonic.com" target="_blank">Panasonic</a> - Energy Recovery Ventilator</li>
        <li><a href="http://www.rohlhome.com" target="_blank">Rohl</a> - Bath Fixtures</li>
        <li><a href="http://www.moen.com" target="_blank">Moen</a> - Kitchen Fixtures</li>
        <li><a href="http://www.trex.com" target="_blank">Trex</a> - Decking</li>
        <li><a href="http://www.mieleusa.com" target="_blank">Miele</a> - Appliances</li>
        <li><a href="http://www.icestone.com" target="_blank">IceStone</a> - Recycled Glass Counters</li>
        <li><a href="http://www.ibew.org" target="_blank">IBEW</a> - Electrical Work</li>
        <li><a href="http://www.bondedlogic.com" target="_blank">Bonded Logic</a> - Recycled Denim Insulation</li>
        <li><a href="http://www.eestairs.com" target="_blank">EEStairs</a> - Ladder to Loft</li>
        <li><a href="http://www.metalroof.net" target="_blank">Metal Roof Network</a> - Metal Roof</li>
        <li><a href="http://www.blanco.com" target="_blank">Blanco</a> - Kitchen Sink</li>
        <li><a href="http://www.jameshardie.com" target="_blank">James Hardie</a> - Siding</li>
        <li><a href="http://www.water-concepts target="_blank".info">Water Concepts</a> - Bathroom FInishes</li>
        <li><a href="http://www.fireclay.com" target="_blank">Fireclay Tile</a> - Recycled Glass Tile</li>
        <li><a href="http://www.teragren.com" target="_blank">Teragren</a> - Bamboo Flooring</li>
        <li><a href="http://www.mythicpaint.com" target="_blank">Mythic Paint</a> - Nontoxic Paint</li>
        <li>Catherine Chang Design Studio - Landscape Design</li>
        <li><a href="http://www.optoelectronix.com" target="_blank">OPTO Electronix</a> - Living Room LED Lighting</li>
        <li><a href="http://www.lumiversal.com" target="_blank">Lumiversal</a> - LED Lighting</li>
        </ul>
        
    EOS,
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
    :short_description => "A peaceful retreat for a couple as the bedroom is separated from the living area for peace and quite.  The loft can be accessed via a circular stair and overlooks the open kitchen and living room.", 
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
    :short_description => "Ideal for a second unit for workspace, guests, or rental opportunity. We've had two firefighters and their baby live in this, but it might be a bit tight for most people to really live in.   Ladders are best reserved for children and firefighters. ", 
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
    :short_description => "An optimal one bedroom that works for downsizing or as a rental opportunity.", 
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
    :short_description => "Ideal for a second home for a family or entertainer. If you consider the loft areas you have almost 800 square feet and two upstairs sleeping/work areas. ", 
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
    :short_description => "Ideal for a modern second home with a very open feel.  With all this glass your eyes can look out towards a garden or view to make it feel bigger.  It's small for a couple but could work for a minimalist looking for a clutter free life. ", 
    :long_description => "The Green Mod offers a uniquely contemporary design with a very open feel. Large windows and high ceilings make its small footprint feel much larger and very comfortable.",
    :teaser_line => "open, bold, modern",
    :album_id => 21,
    :cover_image => File.new(cover_images_path.call("green-mod.jpg")),
    :cover_image_file_name => "green-mod.jpg",
    :is_published => true
  },

 #
 # Client Stories
 #

  {
    :title => "Spring's Cottage: One Bedroom Spanish-Style Cottage in Orinda", # constraint
    :slug => "springs-cottage",
    :position => 1,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 674,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => false,
    :short_description => "See Spring's beautiful 674-square-foot cottage with fireplace and extra large windows built on her daughter's property.", 
    :long_description => "My name is Spring and I'm retired and living in Orinda, CA. After living far from my daughter's family and wanting to be closer, we decided to hire New Avenue to build a cottage on their property. Now I can spend much more time with them and help with childcare while living in a beautiful 674 square foot home tucked between old oaks and giant redwoods. New Avenue helped me design a living space perfect for me with a double sided glass fireplace that faces both the bedroom and the living room and large windows in the kitchen and living room that overlook the Orinda hills. Extra storage is tucked throughout with a nice coat closet at the main door and extra linen storage in the bathroom. I love it! SmartPlanet did a video interview about this project. <a href='http://www.smartplanet.com/video/downsizing-to-an-eco-friendly-home/6335544?tag=search-river' target='_blank'>Click here to watch it!</a>",
    :album_id => 50,
    :cover_image => File.new(cover_images_path.call("springs-cottage.jpg")),
    :cover_image_file_name => "springs-cottage.jpg",
    :is_published => true,
    :image_items => [625, 4463, 4462, 4460, 626, 4471, 4455, 4453, 624]
  },
  {
    :title => "Karen's Cottage: Studio with a Sleeping Loft", # constraint
    :slug => "karens-cottage",
    :position => 2,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 397,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Karen, a UC Berkeley professor, built this custom small home and uses it as a workspace, guest home, and income generator.", 
    :long_description => "My name is Karen and I'm a professor living in Berkeley, CA. I live with my daughter in a beautiful two-bedroom one-bath home and needed a small space that fulfilled a variety of needs, including an independent home for an aging relative who lives with me for several months per year, a sanctuary for my work, a guest house for a steady stream of family and friends, and a little extra income. I chose the Short Line because it met all of these needs with one beautiful design. New Avenue was wonderful how they offered a fixed building price while I chose to customize the design by adding extra storage, several green upgrades, and nicer kitchen and bath finishes. My experience with New Avenue was great and I'd highly recommend them to anyone else with similar needs.",
    :album_id => 30,
    :cover_image => File.new(cover_images_path.call("karens-cottage.jpg")),
    :cover_image_file_name => "karens-cottage.jpg",
    :is_published => true,
    :image_items => [2649, 2648, 2645, 2644, 2647, 2646, 2643, 2542, 2664]
  },
  {
    :title => "Judy's Garden Cottage: Downsizing to a Backyard Cottage in Albany, CA", # constraint
    :slug => "judys-garden-cottage",
    :position => 3,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 442,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Judy's family built this backyard home to give her mother her own space and cottage and secret garden.", 
    :long_description => "My name is Judy and I'm retired and living in Albany, California. My project is unique in that I decided to give my wonderful home to my daughter and grandson to live in, and then build something special for me in the backyard. My neighborhood is a wonderful place for my grandson to grow up with the great Albany school district, BART close by, and a small commercial district with little shops, a pub, and a grocery store. I'm very excited about the house that New Avenue helped me build, complete with Marvin Integrity windows, cedar siding, bamboo flooring, IKEA kitchen cabinets, a flush bathroom floor with tile floor and walls, and an exposed wood ceiling. It's positioned on the lot with a private garden for the cottage and a larger open area that's shared between the two homes. It's perfect for me and my family.",
    :album_id => 445,
    :cover_image => File.new(cover_images_path.call("judys-garden-cottage.jpg")),
    :cover_image_file_name => "judys-garden-cottage.jpg",
    :is_published => true,
    :image_items => [5706, 5692, 6475, 6474, 6461, 6471, 6470, 6468, 6464, 6462, 5709 ]
  },
  {
    :title => "Susan's Cottage: Studio with Upstairs Loft in the East Bay of CA", # constraint
    :slug => "susans-cottage",
    :position => 4,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 469,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "Susan gave her home to her daughter's family and build this wonderful cottage for herself in the backyard.", 
    :long_description => "My name is Susan and I live in East Bay. New Avenue helped me build a wonderful little cottage that I plan to use for many purposes. Right now it offers extra space when my daughter, son-in-law and grandchild are visiting from overseas. And with them contemplating a move here, this may become more of a permanent residence or offer additional living space if they move in with me. When my family isn't using it, I plan to rent it out for additional income, and it gives me the flexibility to rent my entire house so I can travel for longer periods of time, always knowing that the cottage will be there for me if I want to return for a break. It has plenty of room with a separate loft and tons of built in storage and has a shared backyard patio with the main house for outdoor dining with family and guests.",
    :album_id => 138,
    :cover_image => File.new(cover_images_path.call("susans-cottage.jpg")),
    :cover_image_file_name => "susans-cottage.jpg",
    :is_published => true,
    :image_items => [4443, 4451, 4450, 4448, 4447, 4446, 2651]
  },
  {
    :title => "Poppy's Place: Two-Bedroom, Two-Bath Home in Berkeley's Elmwood Neighborhood", # constraint
    :slug => "poppys-place",
    :position => 5,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 1478,
    :number_of_bath => 2,
    :number_of_bed => 2,
    :number_of_stories => 2,
    :has_loft => false,
    :short_description => "Poppy built a large 1500 square foot home in his backyard as an invesment.", 
    :long_description => "My name is Poppy and I live in Berkeley. I purchased a great home in the Elmwood that had an old shack in the backyard. New Avenue has helped me transform the shack into an amazing 1500 square foot house with 4 bedrooms. We were able to save some of the original walls and had sustainability in mind by salvaging some of the original redwood and using spray foam insulation, metal roofing, cement siding, and radiant floor heating. We see the property as a great investment as it's located close to coffee shops, restaurants, and stores on College Avenue, with a walk score of 100. It's a prime rental opportunity for UC Berkeley students or young professionals who pay $3,200-$4,500/mo in rent for comparable properties. With a $1500/month financing payment, we expect to earn at least $2000/month that will help pay our children's upcoming college tuition.",
    :album_id => 371,
    :cover_image => File.new(cover_images_path.call("poppys-place.jpg")),
    :cover_image_file_name => "poppys-place.jpg",
    :is_published => true,
    :image_items => [5203, 5204, 5194, 5201, 5192, 5189, 5199, 5200, 5164, 5181, 5176, 5175, 5186, 5172, 5173, 5168, 2673]
  },
  {
    :title => "Mary's Still Waters Retreat", # constraint
    :slug => "marys-studio",
    :position => 6,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 700,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => false,
    :short_description => "Mary wanted a peaceful workspace that could also be used for guests and entertaining.", 
    :long_description => "My name is Mary and I live in the Willow Glen neighborhood of San Jose. I am a water colorist and often work from home, making it very important for me to have a creative space that fosters calm and creativity. I worked with New Avenue to create a small cottage in my backyard with craftsman details based on their Big L design (link to Big L). Not only do I now have an amazing work space, but I also have a cottage with 2 bedrooms that guests and family can use. I have big french doors that open to a raised deck having plenty of room for entertaining. The entry is level from the driveway so my friends and I can enjoy the space and deck for a long time to come.",
    :album_id => 254,
    :cover_image => File.new(cover_images_path.call("marys-studio.jpg")),
    :cover_image_file_name => "marys-studio.jpg",
    :is_published => true,
    :image_items => [5686, 5685, 5683, 5676, 5680, 2665]
  },
  {
    :title => "Eco House in Palo Alto", # constraint
    :slug => "eco-house-palo-alto",
    :position => 7,
    :category => "Client", # "Floor Plan" or "Client"
    :area => 454,
    :number_of_bath => 1,
    :number_of_bed => 1,
    :number_of_stories => 1,
    :has_loft => true,
    :short_description => "The City of Palo Alto wanted a modular home to serve as a model for sustainability.", 
    :long_description => "My name is Kevin and I work for the City of Palo Alto. We were doing a project with the US Department of Energy and the City of San Jose to create a modular home as a model of sustainability and energy efficiency. We chose New Avenue to build the small modern home and the DOE funded the project, now on display in San Jose. Our small home has a full kitchen, bathroom, laundry, 1 bedroom, and an extra sleeping loft. It's fully wheelchair accessible and incorporates sustainable products including bamboo floors, salvaged windows, Trex decking, Mythic non-toxic paints, recycled glass counters, recycled glass tiles, an efficient mini split heat pump for heating and cooling, solar panels, and a metal roof and rain barrels. Being a modular home, it can be set on any property in the state.",
    :album_id => 372,
    :cover_image => File.new(cover_images_path.call("eco-house.jpg")),
    :cover_image_file_name => "eco-house.jpg",
    :is_published => true,
    :image_items => [4533, 3398, 2737, 2743, 2741, 2732, 2748, 2746, 3389, 2751, 2754, 2760]
  },
]

brochures_data.each do |br|
  puts "SEED > Processing Brochure #{br[:title]}"
  next unless PROCESS_CATEGORY.include? br[:category]
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
    s.cover_image = br[:cover_image] if PROCESS_ATTACHMENTS
    s.is_published = br[:is_published]
  end

  # check album to see if it was actually added
  a = Physical::General::Brochure.find_by(:slug => br[:slug])
  a.album_id = br[:album_id] if a.album == nil
  a.save

end