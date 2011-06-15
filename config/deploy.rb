require "bundler/capistrano"
set :application, "aleph_middleware"
set :domain, "132.248.7.233"
set :scm, :git
set :repository,  "git://github.com/ifunam/aleph_middleware.git"

set :deploy_to, "/var/sinatra/#{application}"
set :use_sudo, false
set :user, "deployer"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true


namespace :deploy do

  task :restart do
    run "cd #{deploy_to}/current && mkdir -p tmp && touch tmp/restart.txt"
  end

  task :update_code do

  end
end
