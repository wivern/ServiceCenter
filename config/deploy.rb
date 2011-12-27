set :application, "service_center"

$LOAD_PATH.unshift File.expand_path('./lib',ENV['rvm_path'])
require 'rvm/capistrano'
require 'bundler/capistrano'
load File.join(File.dirname(__FILE__),"deploy/targets.rb")

set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:wivern/ServiceCenter.git"  # Your clone URL
set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, "master"
set :use_sudo, false

set :scm_verbose, true
set :deploy_via, :remote_cache

#
#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end