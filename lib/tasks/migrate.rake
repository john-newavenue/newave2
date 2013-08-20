namespace :migrate do
  class DBConnectionManager
    DJANGO_DB = {:adapter=>"postgresql", :host => "localhost", "database" => "newave", :username => "postgres"}
    RAILS_DB = {:adapter=>"postgresql", :host => "localhost", "database" => "newave2_development", :username => "newave2"}

    def establish_connection(which)
      @connection = ActiveRecord::Base.establish_connection(which)
    end

    def query(sql, db = nil)
      unless db == nil
        @connection = ActiveRecord::Base.establish_connection(db)
      end
      @connection.connection.execute(sql)
    end

  end

  desc "Deletes all Rails users and projects"
  task :purge => :environment do 
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::RAILS_DB)
    User.delete_all
    Authentication.delete_all
    Physical::Project::Project.delete_all
    Physical::Album::Album.delete_all
    Rake::Task['migrate:purge_items'].invoke
  end

  task :purge_items => :environment do
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::RAILS_DB)
    Physical::Asset::Asset.delete_all
    Physical::Asset::ImageAsset.delete_all
    Physical::Album::AlbumItem.with_deleted.delete_all
  end


  desc "Resets database sequences"
  task :reset_sequences => :environment do
    @db = DBConnectionManager.new
    @db.establish_connection(DBConnectionManager::RAILS_DB)
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    ActiveRecord::Base.connection.reset_pk_sequence!('authentications')
    ActiveRecord::Base.connection.reset_pk_sequence!('projects')
    ActiveRecord::Base.connection.reset_pk_sequence!('albums')
    ActiveRecord::Base.connection.reset_pk_sequence!('album_items')
    ActiveRecord::Base.connection.reset_pk_sequence!('assets')
    ActiveRecord::Base.connection.reset_pk_sequence!('image_assets')
  end


  desc "Migrate users and projects from Django to Rails"
  task :users_and_projects => :environment do

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
      user.save(:validate => false)
      
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