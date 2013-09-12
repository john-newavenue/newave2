namespace :migrate do

  # require 'debugger'

  class DBConnectionManager

    DJANGO_DB = {:adapter=>"postgresql", :host => "localhost", "database" => "newave", :username => "postgres"}
    RAILS_DB = {:adapter=>"postgresql", :host => "localhost", "database" => "newave2_production", :username => "newave2"}
    
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
            "item"."thumbnail_span3_url" AS "item_thumbnail_span3_url",
            "item"."display_image_url" AS "item_display_image_url",
            "item"."imagekit_ttl" AS "item_imagekit_ttl",
            "item"."exhibit_mode" AS "item_exhibit_mode",
            "item"."cover_image" AS "item_cover_image",
            "item"."valid_image" AS "item_valid_image",
            "item"."original_image_width" AS "item_original_image_width",
            "item"."original_image_height" AS "item_original_image_height",
            "item"."original_image_url" AS "item_original_image_url",
            "item"."display_image2_url" AS "item_display_image2_url",
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
          ORDER BY
            "item"."parent_id" DESC,
            "item"."parent_root_id" DESC;
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
    Rake::Task['migrate:setup_rails_db'].invoke
    Rake::Task['migrate:create_users'].invoke
    Rake::Task['migrate:create_projects'].invoke
  end

  desc "Set up a clean Rails environment database using the schema"
  task :setup_rails_db => :environment do 
    puts "MIGRATION > Setting up Rails database"
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:schema:load'].invoke
  end

  # desc "Resets database sequences"
  # task :reset_sequences => :environment do
  #   @db = DBConnectionManager.new
  #   @db.establish_connection(DBConnectionManager::RAILS_DB)
  #   ActiveRecord::Base.connection.reset_pk_sequence!('users')
  #   ActiveRecord::Base.connection.reset_pk_sequence!('authentications')
  #   ActiveRecord::Base.connection.reset_pk_sequence!('projects')
  #   ActiveRecord::Base.connection.reset_pk_sequence!('albums')
  #   ActiveRecord::Base.connection.reset_pk_sequence!('album_items')
  #   ActiveRecord::Base.connection.reset_pk_sequence!('assets')
  #   ActiveRecord::Base.connection.reset_pk_sequence!('image_assets')
  # end


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
        :password => u["user_password"].length < 6 ? (0...8).map { (65 + rand(26)).chr }.join : u["user_password"], # fix imported passwords too short
        :encrypted_password => u["user_password"],
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
    Physical::Project::Project.with_deleted.delete_all
    Physical::Album::Album.with_deleted.delete_all
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
        if User.where(:id => p["user_id"].to_i).count == 1 and project.save
          project.add_user_as_customer()
          puts "Successfully saved project #{project.id} with album #{project.primary_album_id}"
        else
          debugger
          puts "Error with project #{project.id}"
        end
      i = i + 1
    end
  end

  desc "Create Rails Album Items"
  task :create_album_items => :environment do
    Physical::Album::AlbumItem.with_deleted.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('album_items')
    items = @dbm.get_django_resource('estate_items')
    i = 1
    total = items.count

    
    
    # items.each do |i|
    #   puts "Processing estate_item #{i} of #{total}"
    #   album_item = Physical::Album::AlbumItem.new(
    #     :title =>
    #     :description =>
    #     :album_id => i["project_id"].to_i,
    #     :created_at => 
    #     :updated_at => 
    #     :deleted_at => 
    #     :position =>
    #     :parent_id => 
    #     :root_id =>
    #     :credit_name => 
    #     :credit_url =>
    #     :user_id =>
    #     :category_id => nil
    #     :kind => 

    # t.integer  "asset_id"   <=== should drop column
    # t.string   "asset_type" <=== should drop column

    # t.string   "attachment_file_name"
    # t.string   "attachment_content_type"
    # t.integer  "attachment_file_size"
    # t.datetime "attachment_updated_at"
    # t.string   "attachment_type"
    # t.integer  "legacy_asset_id"
    # t.text     "comment"
    # t.string   "kind",                    default: "picture", null: false

    #   )
    #   if album_item.save

    #   else
    #     debugger
    #     puts "Error with album_item"
    #   end
    #   i = i + 1
    # end

  end

# ==================

  desc "Migrate users and projects from Django to Rails"
  task :users_and_projects_old => :environment do

    # clean everything up
    Rake::Task['migrate:purge'].invoke
    Rake::Task['migrate:reset_sequences'].invoke

    # connect to the django DB
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::DJANGO_DB)

    # get old users
    old_users = @db.query('SELECT * FROM auth_user WHERE id < 20 ORDER BY id asc;')
    # old_users = @db.query('SELECT * FROM auth_user ORDER BY id asc;')
    
    # get old social auths
    old_social_relations = @db.query('select * from social_auth_usersocialauth')
    old_social_user_ids = []
    old_social_relations.each { |s| old_social_user_ids.push s["id"].to_i }
  
    # get old projects
    old_projects = @db.query('SELECT * FROM estate_project ORDER BY id asc;')
    old_projects_user_ids = []
    old_projects.each { |p| old_projects_user_ids.push p["user_id"].to_i }

    # connect to rails DB
    @db.establish_connection(DBConnectionManager::RAILS_DB)

    # for each django user create a rails user
    old_users.each do |u|

      # make up a filler email if one doesn't exist
      email = u["email"].blank? ? Devise.friendly_token[0,10] + "@email.com" : u["email"]
      user = User.new(
        :id => u["id"].to_i,
        :username => u["username"],
        :email => email,
        :encrypted_password => u["password"],
        :created_at => Time.parse(u["date_joined"]),
        :slug => u["username"].parameterize
      )
      user.save
      
      # create social authentication if available
      old_social_relation_index = old_social_user_ids.index(user.id)
      if old_social_relation_index
        old_social_relation = old_social_relations[old_social_relation_index]
        token_match = /"([A-Za-z0-9]{30,})"/.match old_social_relation["extra_data"]
        Authentication.create(
          :provider => old_social_relation["provider"],
          :user_id => u["id"],
          :uid =>  old_social_relation["uid"],
          :token => token_match.captures[0]
        )
      end

      # add customer role
      user.add_role :customer

      # create user's projects, if any
      old_projects_user_ids.each_with_index.select do |result,index| 
        if result == user.id
          old_project = old_projects[index]
          project = Physical::Project::Project.new(
            :id => old_project["id"].to_i,
            :title => old_project["title"],
            :created_at => Time.parse(old_project["date_added"]),
            :updated_at => Time.parse(old_project["date_modified"]),
            :deleted_at => old_project["deleted"] == "t" ? Time.now() : nil,
            :private => old_project["private"] == "t" ? true : false
          )
          project.save()
          project.add_user_as_customer(user)
        end
      end
    end

    # reset indices
    Rake::Task['migrate:reset_sequences'].invoke

  end


  desc "Imports project items"
  task :project_items => :environment do

    # clean up, delete everything
    # Rake::Task['migrate:purge_items'].invoke
    # Rake::Task['migrate:reset_sequences'].invoke

    # connect to the django DB
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::DJANGO_DB)

    # get old items
    # old_original_images = @db.query('SELECT * FROM estate_item WHERE id >= 6500 and id < 10000 and item_type=0 and parent_root_id is null ORDER BY id asc;')
    # DONE it all
    old_clipped_images = @db.query('SELECT * FROM estate_item WHERE id >= 2000 and item_type=0 and parent_root_id is not null ORDER BY id asc;')
    # DONE it all

    # connect to rails DB
    @db.establish_connection(DBConnectionManager::RAILS_DB)

    # # for each original item, create an image asset and album item
    # old_original_images_total = old_original_images.count
    # old_original_images.each_with_index do |item, index|
    #   local_image_file = File.new("#{Rails.root}/tmp/old_files/#{item['original_image']}")
    #   image_asset = Physical::Asset::ImageAsset.create(:image => local_image_file)
    #   local_image_file.close()  
    #   album_item = Physical::Album::AlbumItem.create(
    #     :id => item["id"].to_i,
    #     :album_id => item["project_id"].to_i,
    #     :title => item["title"],
    #     :description => "#{item['description']}\n\n#{item['comment']}\n\n#{item['credit_name']}",
    #     :asset => image_asset,
    #     :deleted_at => item["deleted"] == "t" ? Time.now() : nil,
    #     :position => item["project_position"].to_i,
    #     :created_at => Time.parse(item["date_added"]),
    #     :updated_at => Time.parse(item["date_modified"])
    #   )
    #   puts "Processed Original #{index+1} of #{old_original_images_total}: Item ID #{album_item.id}"
    # end

    # for each clipped image, create an album item
    old_clipped_images_total = old_clipped_images.count
    old_clipped_images.each_with_index do |item, index|
      puts "Processing with parent root #{item["parent_root_id"].to_i} and parent #{item["parent_id"].to_i}"
      parent = Physical::Album::AlbumItem.find_by(:id => item["parent_root_id"].to_i)
      image_asset = parent.asset if parent
      if not Physical::Album::AlbumItem.find_by(:id => item["id"].to_i)
        album_item = Physical::Album::AlbumItem.create(
          :id => item["id"].to_i,
          :album_id => item["project_id"].to_i,
          :title => item["title"],
          :description => "#{item['description']}\n\n#{item['comment']}\n\n#{item['credit_name']}",
          :asset => image_asset,
          :deleted_at => item["deleted"] == "t" ? Time.now() : nil,
          :position => item["project_position"].to_i,
          :created_at => Time.parse(item["date_added"]),
          :updated_at => Time.parse(item["date_modified"]),
          :parent_id => item["parent_id"].to_i,
          :root_id => item["parent_root_id"].to_i
        )
        puts "Processed Clipped #{index+1} of #{old_clipped_images_total}: Item ID #{album_item.id}"
      end
    end

    # create a project item message of successful migration

    # reset indices
    Rake::Task['migrate:reset_sequences'].invoke

  end

  desc "Create project item activity"
  task :project_item_activity => :environment do
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::RAILS_DB)

    # Physical::Project::Project.where(:primary_album_id => nil).each do |project|
    #   album = Physical::Album::Album.create(:parent => project, :title => "Project Album")
    #   project.primary_album = album
    #   project.save
    #   puts "Created primary album for #{project.id}"
    # end

    # for each AlbumItem in a Project's Primary Album, create a ProjectItem activity and attached ProjectItemAsset
    Physical::Project::Project.all.each do |project|
      album = project.primary_album
      Physical::Album::AlbumItem.where("album_id = #{project.id}").each do |album_item|
        project_item = Physical::Project::ProjectItem.create(
          :project => project,
          :created_at => album_item.created_at,
          :updated_at => album_item.updated_at
        )
        project_item_asset = Physical::Project::ProjectItemAsset.create(
          :album_item => album_item,
          :project_item => project_item,
          :created_at => album_item.created_at,
          :updated_at => album_item.updated_at
        )
        puts "Completed Project #{project.id} - Album Item #{album_item.id}"
      end
    end
  end

  desc "Check stuff out..."
  task :checker => :environment do
    # is there an album for every project item asset?
    Physical::Project::ProjectItemAsset.all.each do |pia|
      puts "#{pia.id} => #{pia.album_item.id} => #{pia.album_item.album}" if pia.album_item.album == nil
      Physical::Album::Album.create(:parent => pia.project_item.project, :title => "Primary Album") if pia.album_item.album == nil
    end
  end

  desc "Fix albums"
  task :fix_albums => :environment do
    # get all django projects
    # make sure there is an album for every project (match IDs)
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::DJANGO_DB)
    old_projects = @db.query('SELECT * FROM estate_project ORDER BY id asc;')
    @db.establish_connection(DBConnectionManager::RAILS_DB)
    # debugger
    old_projects.each do |old_project|
      album = Physical::Album::Album.find_by(:id => old_project["id"].to_i)
      if album
        album.title = "Primary Album"
        album.parent = Physical::Project::Project.find_by(:id => old_project["id"].to_i)
        album.save
      end
    end
  end

  desc "Fix broken image assets"
  task :fix_broken_image_assets => :environment do
    @db = DBConnectionManager.new
    # album items with asset_type Physical::Asset::ImageAsset but asset_id is null
    # broken_album_items = "(11, 84, 95, 99, 101, 102, 1441, 1445, 1446, 2764, 3491, 3492, 3493, 3494, 3495, 3496, 3497, 3498, 3499, 3500, 3501, 4120, 4378, 4484, 4533, 4534, 4535, 4536, 4537, 4538, 4539, 4540, 4541, 4543, 4544, 4545, 4550, 5078, 5661, 5666, 5667, 5669, 5676, 5685, 5691, 5694, 5706, 5708, 5939, 5940, 6366, 6462, 6465, 6467, 6468, 6472, 6473, 6476)"
    # broken_album_items = "(11, 84, 95, 99, 101, 102)"
    # broken_album_items = "(1441, 1445, 1446, 2764, 3491, 3492, 3493, 3494, 3495, 3496, 3497, 3498, 3499, 3500, 3501, 4120, 4378, 4484, 4533, 4534, 4535, 4536, 4537, 4538, 4539, 4540, 4541, 4543, 4544, 4545, 4550, 5078, 5661, 5666, 5667, 5669, 5676, 5685, 5691, 5694, 5706, 5708, 5939, 5940, 6366, 6462, 6465, 6467, 6468, 6472, 6473, 6476)"
    broken_album_items = "(5078, 2764, 3491, 3492, 3493, 3494, 3495, 3496, 3497, 3498, 3499, 3500, 3501)"

    # unsavable
    broken_album_items = "(3491, 3492, 3493, 3494, 3495, 3496, 3497, 3498, 3499, 3500, 3501, 5078)"

    # get the django items
    @db.establish_connection(DBConnectionManager::DJANGO_DB)
    old_items = {}
    old_items_list = @db.query("SELECT * FROM estate_item WHERE id IN #{broken_album_items}")
    old_items_list.each {|old_item| old_items[old_item["id"].to_i] = old_item }
    # get the rails album items
    @db.establish_connection(DBConnectionManager::RAILS_DB)
    # for each rail record, create the image asset and correct the album item
    Physical::Album::AlbumItem.where("id IN #{broken_album_items}").each do |album_item|
      item = old_items[album_item.id]
      puts "Processing: #{item['id']}"
      local_image_file = File.new("#{Rails.root}/tmp/old_files/#{item['original_image']}")
      image_asset = Physical::Asset::ImageAsset.create(:image => local_image_file)
      if image_asset.save
        local_image_file.close()  
        album_item.update_attributes(
          :album_id => item["project_id"].to_i,
          :title => item["title"],
          :description => "#{item['description']}\n\n#{item['comment']}\n\n#{item['credit_name']}",
          :asset => image_asset,
          :deleted_at => item["deleted"] == "t" ? Time.now() : nil,
          :position => item["project_position"].to_i,
          :created_at => Time.parse(item["date_added"]),
          :updated_at => Time.parse(item["date_modified"])
        )
        if album_item.save
          puts "Saved #{album_item.asset_id} - #{album_item.asset_type} "
        else
          puts "Error with album_item #{album_item.id}"
          puts album_item.errors
        end
      else
        puts "Error with image_asset"
        puts image_asset.errors.messages
        puts item
        puts local_image_file.inspect

      end
      # puts "Processed Original #{index+1} of #{old_original_images_total}: Item ID #{album_item.id}"
    end
  end

  desc "Fix broken image assets 2"
  task :fix_broken_image_assets2 => :environment do
    @db = DBConnectionManager.new
    # album items with asset_type Physical::Asset::ImageAsset but asset_id is null
    broken_album_items = "(195, 224, 494, 501, 668, 821, 829, 847, 1125, 1287, 1300, 1396, 1403, 1422, 1669, 1671, 1813, 1857, 1875, 2010, 2041, 2194, 2455, 2466, 2467, 2468, 2481, 2482, 2501, 2573, 2815, 3476, 3569, 3596, 3612, 3799, 3851, 4004, 4005, 4056, 4132, 4219, 4220, 4221, 4222, 4223, 4224, 4225, 4226, 4227, 4228, 4229, 4230, 4492, 4500, 4530, 4572, 4596, 4680, 4718, 4749, 4854, 4924, 4951, 4952, 4978, 5219, 5590, 5726, 5965, 5996, 6135, 6318, 6386, 6398, 6420)"

    # get the django items
    @db.establish_connection(DBConnectionManager::DJANGO_DB)
    old_items = {}
    old_items_list = @db.query("SELECT * FROM estate_item WHERE id IN #{broken_album_items}")
    old_items_list.each {|old_item| old_items[old_item["id"].to_i] = old_item }
    # get the rails album items
    @db.establish_connection(DBConnectionManager::RAILS_DB)
    # for each rail record, create the image asset and correct the album item
    old_items_list.each do |old_item|
      s = Physical::Album::AlbumItem.with_deleted.where("id = #{old_item["id"].to_i}")

      if s.count == 0
        local_image_file = File.new("#{Rails.root}/tmp/old_files/#{item['original_image']}")
        image_asset = Physical::Asset::ImageAsset.new(:image => local_image_file)
        puts "#{local_image_file.inspect}"
        if image_asset.save
          a = Physical::Album::AlbumItem.create(
            :id => old_item["id"].to_i,
            :album_id => item["project_id"].to_i,
            :title => item["title"],
            :description => "#{item['description']}\n\n#{item['comment']}\n\n#{item['credit_name']}",
            :asset => image_asset,
            :deleted_at => item["deleted"] == "t" ? Time.now() : nil,
            :position => item["project_position"].to_i,
            :created_at => Time.parse(item["date_added"]),
            :updated_at => Time.parse(item["date_modified"])
          )
        else
          puts "error image #{local_image_file.inspect}"
        end
      else 
        a = s.first
        parent = Physical::Album::AlbumItem.with_deleted.find(a.parent_id)
        parent.deleted_at = nil
        debugger
        parent.save
      end
      if a.save
        puts "completed #{a.id}"
      else
        puts "ERROR #{a.id}"
      end
    end



    # Physical::Album::AlbumItem.where("id IN #{broken_album_items}").each do |album_item|
    #   item = old_items[album_item.id]
    #   puts "Processing: #{item['id']}"
    #   local_image_file = File.new("#{Rails.root}/tmp/old_files/#{item['original_image']}")
    #   image_asset = Physical::Asset::ImageAsset.create(:image => local_image_file)
    #   if image_asset.save
    #     local_image_file.close()  
    #     album_item.update_attributes(
    #       :album_id => item["project_id"].to_i,
    #       :title => item["title"],
    #       :description => "#{item['description']}\n\n#{item['comment']}\n\n#{item['credit_name']}",
    #       :asset => image_asset,
    #       :deleted_at => item["deleted"] == "t" ? Time.now() : nil,
    #       :position => item["project_position"].to_i,
    #       :created_at => Time.parse(item["date_added"]),
    #       :updated_at => Time.parse(item["date_modified"])
    #     )
    #     if album_item.save
    #       puts "Saved #{album_item.asset_id} - #{album_item.asset_type} "
    #     else
    #       puts "Error with album_item #{album_item.id}"
    #       puts album_item.errors
    #     end
    #   else
    #     puts "Error with image_asset"
    #     puts image_asset.errors.messages
    #     puts item
    #     puts local_image_file.inspect

    #   end
    #   # puts "Processed Original #{index+1} of #{old_original_images_total}: Item ID #{album_item.id}"
  end

  desc "Add meta info"
  task :fix_meta => :environment do
    # add description
    # add comment
    # add credit name
    # add credit URL

    # create fields for credits

    # get all django old original items
    # find all original items
      # fill out credit name and url

    # get all items
      # fill out description
      # fill out comment

  end


end