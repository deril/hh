# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'HH'
set :repo_url, 'git@github.com:Fattaf/hh.git'

# Default branch is :master
ask :branch, "capistrano" #proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/hh'

# Default value for :scm is :git
set :scm, :git

set :use_sudo, false

set :rails_env, "production"

set :deploy_via, :copy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log  public}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  desc 'generate secret token'
  task :generate_secret do
    on roles(:app), wait: 5 do
      within release_path do
        execute :rake, 'secret_token:generate'
      end
    end
  end

  desc 'work with server'
  task :restart do
    on roles(:app) do
      # execute "/opt/nginx/sbin/nginx -s reload"
      execute 'service nginx restart'
    end
  end

  before :deploy, "deploy:check"
  after :finishing, "deploy:migrate"
  after :finishing, 'deploy:cleanup'
  after :finishing, :generate_secret

  after :finishing, "deploy:log_revision"
  after :publishing, 'deploy:restart'
end