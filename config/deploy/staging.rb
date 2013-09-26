require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano-db-tasks'

set :application, "newave2"
set :repository,  "https://github.com/justinm715/newave2"
set :deploy_to, "/var/www/dev.newavenuehomes.com"
set :scm, :git

role :web, "dev.newavenuehomes.com"                          # Your HTTP server, Apache/etc
role :app, "dev.newavenuehomes.com"                          # This may be the same as your `Web` server
role :db,  "dev.newavenuehomes.com", :primary => true        # This is where Rails migrations will run

set :rvm_ruby_string, 'ruby-2.0.0-p247@newave2-staging'
set :rvm_type, :system

set :user, "root"
set :rails_env, "staging"
set :keep_releases, 5

default_run_options[:pty] = true

# role :db,  "your slave db-server here"

set :db_local_clean, true # capistrano-db-tasks, remove dump file after loading

after "deploy:create_symlink", "deploy:symlink_config_files"
after "deploy:restart", "deploy:cleanup"

namespace :deploy do

  task :start do
    run "cd #{current_path} && bundle exec thin -C #{current_path}/config/thin/staging.yml start "
  end

  task :stop do
    run "cd #{current_path} && bundle exec thin -C #{current_path}/config/thin/staging.yml stop "
  end

  task :restart do
    run "cd #{current_path} && bundle exec thin -C #{current_path}/config/thin/staging.yml restart "
  end

  desc "Create symlinks to sensitive config files"
  task :symlink_config_files do
    run "#{try_sudo} ln -s #{deploy_to}/shared/config/application.yml #{current_path}/config/application.yml"

  end

  desc "Import a database dump"
  task :import_database_dump do
    run "dropdb -U #{db_username} #{db_database}"
    run "createdb -U #{db_username} #{db_database}"
    run "cat #{dump_path} | gunzip | psql -U #{db_username} #{db_database}"
  end

end
