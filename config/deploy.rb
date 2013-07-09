require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano-db-tasks'

set :application, "newave2"
set :repository,  "https://github.com/justinm715/newave2"
set :deploy_to, "/var/www/beta.newavenuehomes.com"
set :scm, :git

role :web, "beta.newavenuehomes.com"                          # Your HTTP server, Apache/etc
role :app, "beta.newavenuehomes.com"                          # This may be the same as your `Web` server
role :db,  "beta.newavenuehomes.com", :primary => true        # This is where Rails migrations will run

set :rvm_ruby_string, 'ruby-2.0.0-p247@newave2'
set :rvm_type, :system

set :user, "root"
set :rails_env, "production"
set :keep_releases, 5

default_run_options[:pty] = true

# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts


set :db_local_clean, true # capistrano-db-tasks, remove dump file after loading

after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"

namespace :deploy do

  task :start do
    run "cd #{current_path} && bundle exec thin -C #{current_path}/config/thin.yml start "
  end

  task :stop do
    run "cd #{current_path} && bundle exec thin -C #{current_path}/config/thin.yml stop "
  end

  task :restart do
    run "cd #{current_path} && bundle exec thin -C #{current_path}/config/thin.yml restart "
  end

  desc "Create symlinks to sensitive config files"
  task :symlink_config_files do
    run "#{try_sudo} ln -s #{deploy_to}/shared/config/application.yml #{current_path}/config/application.yml"
  end

end

# environment_database = "newave2_production"

# namespace :db do

  # task :backup_name, :roles => :db, :only => { :primary => true } do
  #   now = Time.now
  #   run "mkdir -p #{shared_path}/db_backups"
  #   backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
  #   set :backup_file, "#{shared_path}/db_backups/#{environment_database}-snapshot-#{backup_time}.sql"
  # end

  # desc "Backup your MySQL or PostgreSQL database to shared_path+/db_backups"
  # task :dump, :roles => :db, :only => {:primary => true} do
  #   backup_name
  #   debugger

  #   run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }
  #   dbuser = @environment_info['username']
  #   dbpass = @environment_info['password']
  #   environment_database = @environment_info['database']
  #   dbhost = @environment_info['host']
  #   if @environment_info['adapter'] == 'mysql'
  #     #dbhost = environment_dbhost.sub('-master', '') + '-replica' if dbhost != 'localhost' # added for Solo offering, which uses localhost
  #     run "mysqldump --add-drop-table -u #{dbuser} -h #{dbhost} -p #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
  #       ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
  #     end
  #   else
  #     run "pg_dump -W -c -U #{dbuser} -h #{dbhost} #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
  #       ch.send_data "#{dbpass}\n" if out=~ /^Password:/
  #     end
  #   end
  # end

#   desc "Sync your production database to your local workstation"
#   task :clone_to_local, :roles => :db, :only => {:primary => true} do
#     backup_name
#     dump
#     get "#{backup_file}.bz2", "/tmp/#{application}.sql.bz2"
#     development_info = YAML.load_file("config/database.yml")['development']
#     if development_info['adapter'] == 'mysql'
#       run_str = "bzcat /tmp/#{application}.sql.bz2 | mysql -u #{development_info['username']} --password='#{development_info['password']}' -h #{development_info['host']} #{development_info['database']}"
#     else
#       run_str = "PGPASSWORD=#{development_info['password']} bzcat /tmp/#{application}.sql.bz2 | psql -U #{development_info['username']} -h #{development_info['host']} #{development_info['database']}"
#     end
#     %x!#{run_str}!
#   end

# end