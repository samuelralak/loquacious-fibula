# config valid only for Capistrano 3.1
lock '3.1.0'

server '158.255.1.132', roles: [:web, :app, :db], primary: true

set :application, 'avtomat_kalashnikova'
set :deploy_to, "/home/deploy/apps/avtomat_kalashnikova"
set :deployer_via, :remote_cache
set :use_sudo, false
set :puma_threads,    [4, 16]
set :puma_workers,    0

set :scm, :git
set :repo_url, 'git@github.com:sidralak/loquacious-fibula.git'

# Don't change these unless you know what you're doing
set :pty,             true
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/deploy/apps/avtomat_kalashnikova"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/avtomat_kalashnikova-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml config/sidekiq.yml log/sidekiq.log}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart

  # desc 'Restart application'
  # task :restart do
    # on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    # end
  # end

  # after :publishing, 'deploy:restart'
  # after :finishing, 'deploy:cleanup'

  # after :restart, :clear_cache do
    # on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    # end
  # end

end

# For capistrano 3
namespace :sidekiq do
    task :quiet do
        on roles(:app) do
            # Horrible hack to get PID without having to use terrible PID files
            puts capture("kill -USR1 $(sudo initctl status workers | grep /running | awk '{print $NF}') || :")
        end
    end
    task :restart do
        on roles(:app) do
            execute :sudo, :initctl, :restart, :workers
        end
    end
end

# after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'

# If you wish to use Inspeqtor to monitor Sidekiq
# https://github.com/mperham/inspeqtor/wiki/Deployments
#namespace :inspeqtor do
    #task :start do
        #execute :inspeqtorctl, :start, :deploy
    #end
    #task :finish do
        #execute :inspeqtorctl, :finish, :deploy
    #end
#end

# before 'deploy:starting', 'inspeqtor:start'
# after 'deploy:finished', 'inspeqtor:finish'





# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma