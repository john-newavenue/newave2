namespace :migrate do

  # require 'debugger'

  class DBConnectionManager

    DJANGO_DB = {:adapter=>"postgresql", :host => "localhost", "database" => "newave", :username => "postgres"}
    RAILS_DB = {:adapter=>"postgresql", :host => "localhost", "database" => Rails.configuration.database_configuration[Rails.env]["database"], :username => "newave2"}
    
    @which_db = nil
    @connection = nil

    def establish_connection(which)
      puts "DBConnectionManager > Establishing connection to: #{which}"
      @which_db = which
      @connection = ActiveRecord::Base.establish_connection(@which_db)
    end

    def query(sql, db = @which_db)
      puts "DBConnectionManager > Executing query: #{sql} "
      unless db == nil
        @connection = ActiveRecord::Base.establish_connection(db)
      end
      @connection.connection.execute(sql)
    end

    def get_django_resource(resource)
      r = nil
      establish_connection(DJANGO_DB)

      case resource
      when 'users'
        r = query('
          SELECT 
            "user"."id" AS "user_id",
            "user"."username" AS "user_username",
            "user"."email" AS "user_email",
            "user"."password" AS "user_password",
            "user"."date_joined" AS "user_created_at",
            "socialauth"."id" AS "socialauth_id",
            "socialauth"."provider" AS "socialauth_provider",
            "socialauth"."uid" AS "socialauth_uid",
            "socialauth"."extra_data" AS "socialauth_extra_data"
          FROM
            "auth_user" AS "user"
          LEFT JOIN 
            "social_auth_usersocialauth" AS "socialauth"
          ON
            "user"."id" = "socialauth"."user_id"
          WHERE
            "user"."id" > 0
          ORDER BY
            "user"."id" ASC
        ')
      # when 'socialauths'
      #   r = query('select * from social_auth_usersocialauth')
      when 'design_books'
        r = query('SELECT * FROM estate_project ORDER BY id asc;')
      when 'estate_items'
        r = query('
          SELECT 
            "item"."id" AS "item_id",
            "item"."user_id" AS "item_user_id",
            "item"."space_id" AS "item_space_id",
            "item"."project_id" AS "item_project_id",
            "item"."title" AS "item_title",
            "item"."private" AS "item_private",
            "item"."deleted" AS "item_deleted",
            "item"."cloned" AS "item_cloned",
            "item"."position" AS "item_position",
            "item"."date_added" AS "item_date_added",
            "item"."date_modified" AS "item_date_modified",
            "item"."item_type" AS "item_item_type",
            "item"."description" AS "item_description",
            "item"."comment" AS "item_comment",
            "item"."parent_id" AS "item_parent_id",
            "item"."original_image" AS "item_original_image",
            "item"."attachment" AS "item_attachment",
            "item"."url" AS "item_url",
            "item"."credit_url" AS "item_credit_url",
            "item"."credit_name" AS "item_credit_name",
            "item"."parent_root_id" AS "item_parent_root_id",
            "item"."imagekit_ttl" AS "item_imagekit_ttl",
            "item"."exhibit_mode" AS "item_exhibit_mode",
            "item"."cover_image" AS "item_cover_image",
            "item"."valid_image" AS "item_valid_image",
            "item"."original_image_width" AS "item_original_image_width",
            "item"."original_image_height" AS "item_original_image_height",

            "item"."thumbnail_span3_url" AS "item_thumbnail_span3_url",
            "item"."display_image_url" AS "item_display_image_url",
            "item"."original_image_url" AS "item_original_image_url",
            "item"."display_image2_url" AS "item_display_image2_url",

            "parent_item"."thumbnail_span3_url" AS "parent_item_thumbnail_span3_url",
            "parent_item"."display_image_url" AS "parent_item_display_image_url",
            "parent_item"."original_image_url" AS "parent_item_original_image_url",
            "parent_item"."display_image2_url" AS "parent_item_display_image2_url",

            "root_item"."thumbnail_span3_url" AS "root_item_thumbnail_span3_url",
            "root_item"."display_image_url" AS "root_item_display_image_url",
            "root_item"."original_image_url" AS "root_item_original_image_url",
            "root_item"."display_image2_url" AS "root_item_display_image2_url",

            "item"."project_position" AS "item_project_position",
            "item"."space_position" AS "item_space_position",
            "space"."id" AS "space_id",
            "space"."user_id" AS "space_user_id",
            "space"."title" AS "space_title",
            "space"."description" AS "space_description",
            "space"."private" AS "space_private",
            "space"."deleted" AS "space_deleted",
            "space"."cloned" AS "space_cloned",
            "space"."parent_id" AS "space_parent_id",
            "space"."position" AS "space_position",
            "space"."project_id" AS "space_project_id",
            "space"."space_type_id" AS "space_space_type_id",
            "space"."date_added" AS "space_date_added",
            "space"."date_modified" AS "space_date_modified",
            "space"."exhibit_mode" AS "space_exhibit_mode"
          FROM
            "estate_item" AS "item"
          LEFT JOIN
            "estate_space" AS "space"
          ON
            "item"."space_id" = "space"."id"
          LEFT JOIN
            "estate_item" AS "parent_item"
          ON
            "item"."parent_id" = "parent_item"."id"
          LEFT JOIN
            "estate_item" AS "root_item"
          ON
            "item"."parent_root_id" = "root_item"."id"
          ORDER BY
            "item"."parent_id" DESC,
            "item"."parent_root_id" DESC,
            "item"."id" ASC
          ')
      end
      establish_connection(RAILS_DB)
      r
    end

  end

  @dbm = DBConnectionManager.new

  desc "Run all migration procedures"
  task :run => :environment do
    puts "MIGRATION > Running everything. Here goes!"
    s = Time.now
    Rake::Task['migrate:setup_rails_db'].invoke
    Rake::Task['migrate:create_users'].invoke
    Rake::Task['migrate:create_projects'].invoke
    Rake::Task['migrate:assign_admin'].invoke
    Rake::Task['migrate:advance_keys'].invoke
    Rake::Task['db:seed_fu filter=architects'].invoke
    puts "MIGRATION > Took #{Time.now - s} seconds"
  end

  desc "Set up a clean Rails environment database using the schema"
  task :setup_rails_db => :environment do 
    puts "MIGRATION > Setting up Rails database"
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:schema:load'].invoke
    Rake::Task['db:seed'].invoke
  end

  desc "Migrate users and projects from Django to Rails"
  task :create_users => :environment do
    
    User.delete_all
    Authentication.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    ActiveRecord::Base.connection.reset_pk_sequence!('authentications')

    django_users = @dbm.get_django_resource('users')

    i = 1
    total = django_users.count

    django_users.each do |u|
      puts "Processing user #{i} of #{total}"
      # create Rails user
      user = User.new(
        :id => u["user_id"].to_i,
        :username => u["user_username"].length > 2 ? u["user_username"] : u["user_username"] + "1", # fix imported emails short
        :email => ( u["user_email"].blank? or not Devise.email_regexp.match(u["user_email"]) ) ? Devise.friendly_token[0,10] + "@email.com" : u["user_email"],
        # :password => u["user_password"].length < 6 ? (0...8).map { (65 + rand(26)).chr }.join : u["user_password"], # fix imported passwords too short
        :password => "password",
        :created_at => Time.parse(u["user_created_at"]),
        :slug => u["user_username"].parameterize
      )
      if user.save
        puts "Successfully saved user #{user.id}"
      else
        debugger
        puts "Error with user #{user.id}"
      end
       
      user.add_role :customer
      # if needed, create Authentication association
      unless u["socialauth_uid"] == nil
        token = /"([A-Za-z0-9]{30,})"/.match(u["socialauth_extra_data"])
        auth = Authentication.new(
          :user_id => u["user_id"],
          :provider => u["socialauth_provider"],
          :uid => u["socialauth_uid"],
          :token => token ? token.captures[0] : nil
        )
        if auth.save
          puts "Successfully saved auth #{auth.id}"
        else
          debugger
          puts "Error with auth #{auth.id}"
        end
      end
      i = i + 1
    end
  end

  desc "Create Rails projects (albums created with project after_create)"
  task :create_projects => :environment do
    Physical::Project::Project.delete_all
    Physical::Album::Album.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('projects')
    ActiveRecord::Base.connection.reset_pk_sequence!('albums')

    django_projects = @dbm.get_django_resource('design_books')
    i = 1
    total = django_projects.count
    django_projects.each do |p|
      puts "Processing project #{i} of #{total}"
      project = Physical::Project::Project.new(
        :id => p["id"].to_i,
        :title => p["title"],
        :created_at => Time.parse(p["date_added"]),
        :updated_at => Time.parse(p["date_modified"]),
        :deleted_at => p["deleted"] == "t" ? Time.now() : nil,
        :private => p["private"] == "t" ? true : false
      )
        if User.where(:id => p["user_id"].to_i).count == 1 and project.valid? and project.save
          project.add_user_as_customer(User.find(p["user_id"].to_i))

          puts "Successfully saved project #{project.id} with album #{project.primary_album_id}"
          # debugger
          # puts "hi"
          # if project.primary_album_id != p["id"].to_i
          #   project.primary_album = Physical::Album::Album.create(
          #     :id => p["id"].to_i,
          #     :parent => project,
          #     :title => "Primary Album"
          #   )
          #   project.save
          # end
        else
          debugger
          puts "Error with project #{project.id}"
        end
      i = i + 1
    end
  end

  desc "Create Rails Album Items"
  task :create_album_items => :environment do

    Physical::Album::AlbumItem.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('album_items')

    Physical::Project::ProjectItemAsset.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('project_item_assets')

    Physical::Project::ProjectItem.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('project_items')

    items = @dbm.get_django_resource('estate_items')
    j = 1
    total = items.count
    legacy_cdn_url = "http://e106ce00de004b7393de-0058d95ebdf51c2bd9f43fd0921533e4.r92.cf1.rackcdn.com/"

    def resolve_description(item)
      desc = item["item_description"]
      comm = item["item_comment"]
      result = ""
      if not desc.blank?
        result = desc
      end
      if not comm.blank?
        result = result.blank? ? comm : result + "\n\n Comment: #{comm}"
      end
      result
    end

    def resolve_category(item)

     # SELECT DISTINCT("space"."title") as "space_title" FROM "estate_item" AS "item" LEFT JOIN "estate_space" AS "space" ON "item"."space_id" = "space"."id";
     # Office
     # Guest House
     # Architectural Style
     # Living Room
     # 1000 sq. foot cottage
     # Loft
     # Floor Plans
     # Systems and Sustainability
     # Living Space
     # Construction
     # Kitchen
     # Bathroom
     # Private Bathroom
     # Windows and Doors
     # Workshop
     # Kitty's Bedroom
     # Entry and Outdoor Space
     # Breezeway and Greenhouse
     # Art Studio  - The Old Garage
     # Bedroom

     # [
     #  'Architectural Style', 1
     #  'Floor Plans', 2
     #  'Construction', 3
     #  'Kitchen', 4
     #  'Bathroom', 5
     #  'Bedroom', 6
     #  'Living Room', 7
     #  'Dining Room', 8
     #  'Entry and Outdoors', 9
     #  'Kids', 10
     #  'Office', 11
     #  'Storage', 12
     #  'Systems and Sustainability', 13
     #  'Uncategorized' 14
     # ]

     item_space = item["space_title"]
     possibilities = {
       "Office" => 11,
       "Guest House" => 1,
       "Architectural Style" => 1,
       "Living Room" => 7,
       "1000 sq. foot cottage" => 1,
       "Loft" => 6,
       "Floor Plans" => 2,
       "Systems and Sustainability" => 13,
       "Living Space" => 7,
       "Construction" => 3,
       "Kitchen" => 4,
       "Bathroom" => 5,
       "Private Bathroom" => 5,
       "Windows and Doors" => 1,
       "Workshop" => 1,
       "Kitty's Bedroom" => 6,
       "Entry and Outdoor Space" => 9,
       "Breezeway and Greenhouse" => 9,
       "Art Studio  - The Old Garage" => 11,
       "Bedroom" => 6
     }

     r = possibilities[item_space]
     return r if r
     return 14
    end

    def resolve_legacy_image_url(item)
      legacy_cdn_url = "http://e106ce00de004b7393de-0058d95ebdf51c2bd9f43fd0921533e4.r92.cf1.rackcdn.com/"
      if item["item_item_type"].to_i == 0 # if a picture
        if (item["item_parent_id"].to_i == 0 or item["item_parent_id"].nil?) # if no parent, must be original
          return {
            :legacy_original_image_url => item["item_original_image_url"].nil? ? (legacy_cdn_url + item["item_original_image"]) : (legacy_cdn_url + item["item_original_image_url"]),
            :legacy_thumbnail_span3_url => item["item_thumbnail_span3_url"],
            :legacy_display_image_url => item["item_display_image_url"],
            :legacy_display_image2_url => item["item_display_image2_url"]
          }
        elsif not item["parent_item_original_image_url"].nil? #   try to get urls from parent
          return {
            :legacy_original_image_url => item["parent_item_original_image_url"],
            :legacy_thumbnail_span3_url => item["parent_item_thumbnail_span3_url"],
            :legacy_display_image_url => item["parent_item_display_image_url"],
            :legacy_display_image2_url => item["parent_item_display_image2_url"]
          }
        else # try to get urls from root
          return {
            :legacy_original_image_url => item["root_item_original_image_url"],
            :legacy_thumbnail_span3_url => item["root_item_thumbnail_span3_url"],
            :legacy_display_image_url => item["root_item_display_image_url"],
            :legacy_display_image2_url => item["root_item_display_image2_url"]
          }
        end
      else
        return {
          :legacy_original_image_url => nil,
          :legacy_thumbnail_span3_url => nil,
          :legacy_display_image_url => nil,
          :legacy_display_image2_url => nil
        }
      end
    end

    items.each do |i|
      puts "Processing estate_item #{j} of #{total}"
      legacy_image_urls = resolve_legacy_image_url(i)

      album_item = Physical::Album::AlbumItem.new(
        :id => i["item_id"],
        :title => i["item_title"],
        :description =>  resolve_description(i),
        :album_id => i["item_project_id"].to_i == 0 ? 1 : i["item_project_id"].to_i,
        :created_at => Time.parse(i["item_date_added"]),
        :updated_at => Time.parse(i["item_date_modified"]),
        :deleted_at => i["item_deleted"] == "t" ? Time.now() : nil,
        :position => i["space_position"].to_i,
        :parent_id => i["item_parent_id"].to_i == 0 ? nil : i["item_parent_id"].to_i,
        :root_id => i["item_parent_root_id"].to_i == 0 ? nil : i["item_parent_root_id"].to_i,
        :credit_name => i["item_credit_name"],
        :credit_url => i["item_credit_url"],
        :user_id => i["item_user_id"].to_i,
        :category_id => resolve_category(i),
        :kind => (i["item_item_type"].to_i == 0 ? "picture" : "text"),
        :attachment_type => (i["item_item_type"].to_i == 0 ? "image" : "other"),

        # :legacy_original_image_url => i["item_original_image_url"] ? i["item_original_image_url"] : nil ,
        # :legacy_thumbnail_span3_url => i["item_original_image_url"] ? i["item_thumbnail_span3_url"] : nil ,
        # :legacy_display_image_url => i["item_original_image_url"] ? i["item_display_image_url"]  : nil ,
        # :legacy_display_image2_url => i["item_original_image_url"] ? i["item_display_image2_url"] : nil

        :legacy_original_image_url => legacy_image_urls[:legacy_original_image_url],
        :legacy_thumbnail_span3_url => legacy_image_urls[:legacy_thumbnail_span3_url],
        :legacy_display_image_url => legacy_image_urls[:legacy_display_image_url],
        :legacy_display_image2_url => legacy_image_urls[:legacy_display_image2_url]
      )

    # t.integer  "asset_id"   <=== should drop column
    # t.string   "asset_type" <=== should drop column

    # t.string   "attachment_file_name"
    # t.string   "attachment_content_type"
    # t.integer  "attachment_file_size"
    # t.datetime "attachment_updated_at"
    # t.string   "attachment_type"
    # t.integer  "legacy_asset_id"
    # t.text     "comment"

      begin
        if album_item.valid? and album_item.save(:validate => false)
          puts "Successfully saved album_item #{album_item.id}"
          
          # rectify timeline activity, which was created last
          p = Physical::Project::ProjectItem.order('id DESC').first
          p.created_at = Time.parse(i["item_date_added"])
          p.updated_at = Time.parse(i["item_date_modified"])
          p.deleted_at = album_item.deleted_at
          
          p.category = "uploaded_picture" if (i["item_parent_id"].nil? and i["item_item_type"].to_i == 0)
          p.category = "clipped_picture" if (i["item_parent_id"].to_i > 0 and i["item_item_type"].to_i == 0)
          p.category = "text" if not p.category
          
          p.user_id = (i["item_user_id"].to_i == 0 or i["item_user_id"].nil?) ? 1 : i["item_user_id"].to_i
          p.project_id = (i["item_project_id"].to_i == 0 or i["item_project_id"].nil?) ? 1 : i["item_project_id"].to_i

          if p.valid? and p.save(:validate => false)

          else
            puts p.errors
            debugger

          end
        else
          debugger
          puts album_item.errors
          puts "Error with album_item"
        end
      rescue
        puts "MIGRATION > Rescue"
        debugger
        puts "Rescue ended"
      end


      j = j + 1
    end

  end

  desc "Assign admin role to AbigailMathews"
  task :assign_admin => :environment do
    User.find(1).add_role :admin
  end

  desc "Advance primary keys for all tables"
  task :advance_keys => :environment do 
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    ActiveRecord::Base.connection.reset_pk_sequence!('authentications')
    ActiveRecord::Base.connection.reset_pk_sequence!('projects')
    ActiveRecord::Base.connection.reset_pk_sequence!('albums')
    ActiveRecord::Base.connection.reset_pk_sequence!('album_items')
  end

  desc "Push to staging"
  task :push_to_staging => :environment do
    # stop staging server
    system "RAILS_ENV=staging cap deploy:stop"

    # some variables
    db_config = Rails.configuration.database_configuration[Rails.env]
    server_location = "newavenuehomes.com"
    timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

    # dump local database
    dump_filename = "db_#{Rails.env}_#{timestamp}.gz"
    local_dump_path =  "#{Rails.root}/tmp/#{dump_filename}"
    system "pg_dump -U #{db_config['username']} #{db_config['database']} | gzip > #{local_dump_path}"

    # upload database to remote
    remote_dump_dir = "/tmp"
    remote_dump_path = "#{remote_dump_dir}/#{dump_filename}"
    system "scp #{local_dump_path} root@#{server_location}:#{remote_dump_dir}"

    # import data
    system "RAILS_ENV=staging cap deploy:import_database_dump -s dump_path=#{remote_dump_path} -s db_username=postgres -s db_database=#{db_config['database']}"

    # start staging server
    system "RAILS_ENV=staging cap deploy:start"
  end

end