# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "poker-game"
set :repo_url, "git@bitbucket.org:madcat-elisa/server.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ec2-user/poker-game"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 20

set :puma_bind,       "unix://#{shared_path}/sockets/puma.sock"
set :puma_state,      "#{shared_path}/pids/puma.state"
set :puma_pid,        "#{shared_path}/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: ["#{Dir.home}/.ssh/madcat-aws.pem"]
}

namespace :deploy do

  task :say_hi do
    print "Hi :)\n"
  end

  task :migrate do
    set :rails_env, fetch(:stage)
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:migrate'
        end
      end
    end
  end

  after "deploy", "deploy:say_hi"
  after "deploy:publishing", "deploy:migrate"
  after "deploy:log_revision", "deploy:restart"
    
end

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
    execute "mkdir #{shared_path}/sockets -p"
    execute "mkdir #{shared_path}/pids -p"
    end
  end

  before :start, :make_dirs
end
