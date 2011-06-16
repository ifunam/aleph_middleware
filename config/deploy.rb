require "bundler/capistrano"
set :application, "aleph_middleware"
set :domain, "132.248.7.233"
set :use_sudo, false
set :user, "deployer"

set :scm, :git
set :repository,  "git://github.com/ifunam/aleph_middleware.git"

set :deploy_to, "/var/sinatra/#{application}"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

#set :app, domain
#set :web, domain
#set :db, domain

server domain, :app, :web, :db, :primary => true
namespace :deploy do

  task :restart do
    run "mkdir -p #{current_path}/tmp"
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :update_code do
   run "ln -nfs #{deploy_to}/share/aleph_middleware/config.yml #{release_path}/config.yml"
  end
end
