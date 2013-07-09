require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "newave2"
set :repository,  "https://github.com/justinm715/newave2"
set :deploy_to, "/var/www/beta.newavenuehomes.com"


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

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

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy
  task :start do ; end
  task :stop do ; end
  task :restart do
    run "cd #{current_path} && bundle exec thin restart -C #{current_path}/config/thin.yml"
  end
end