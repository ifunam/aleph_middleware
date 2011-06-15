set :application, "aleph_middleware"
set :domain, "alephsucks.fisica.unam.mx"
set :repository,  "git://github.com/ifunam/aleph_middleware.git"

set :deploy_to, "/var/sinatra/#{application}"
default_run_options[:pty] = true
set :use_sudo, false
set :user, "deployer"

set :scm, :git

namespace :deploy do

  task :restart do
    run "cd #{deploy_to}/current && mkdir -p tmp && touch tmp/restart.txt"
  end

end
