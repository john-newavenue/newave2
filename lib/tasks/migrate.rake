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

end