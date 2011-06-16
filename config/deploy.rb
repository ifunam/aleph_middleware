require "bundler/capistrano"
set :application, "aleph_middleware"
set :domain, "132.248.7.233"
set :use_sudo, false
set :user, "deployer"
set :deploy_to, "/var/sinatra/#{application}"
set :deploy_via, :remote_cache

set :scm, :git
set :git_shallow_clone,1
set :repository,  "git://github.com/ifunam/aleph_middleware.git"
set :branch, "master"

default_run_options[:pty] = true
server domain, :app, :web, :db, :primary => true

namespace :deploy do

  task :update do
    revision_number = Time.now.strftime("%Y%m%d%H%m%S")
    run "git clone #{repository} #{deploy_to}/releases/#{revision_number}"
    run "mkdir -p  #{deploy_to}/releases/#{revision_number}/tmp"
    run "mkdir -p  #{deploy_to}/releases/#{revision_number}/public"
    run "ln -nsf #{deploy_to}/releases/#{revision_number}  #{deploy_to}/current"
    run "ln -nfs #{deploy_to}/shared/system/config.yml  #{deploy_to}/current/config.yml"
  end

  task :restart do
   run "touch #{current_path}/tmp/restart.txt"
  end

end
