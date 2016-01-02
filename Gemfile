source 'https://rubygems.org'

# base
gem 'rails', '4.1.5'

# db
gem 'mysql2'

# image processing
gem 'rmagick', '2.13.2'
gem "paperclip", "~> 4.1"

# login
gem 'devise'

#views
gem 'haml', '~> 4.0.5'
gem 'kaminari'
gem 'formtastic'

# js
gem 'execjs'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'coffee-rails', '~> 4.0.0'

# styles
gem 'sass-rails', '~> 4.0.3'
gem 'susy'
gem 'compass', '>= 0.12.2'
gem 'compass-rails', '>= 1.0.3'

# assets compressor
gem 'uglifier', '>= 1.3.0'

# seo
gem 'metamagic'
gem 'sitemap_generator'

# metrics
gem 'newrelic_rpm'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :test do
  # server
  gem 'thin', require: false

  # test frameworks
  gem 'rspec-rails'
  gem 'capybara'
  gem "parallel_tests", "0.6.17"

  # detectors & metrics
  gem 'simplecov', require: false
  gem 'rack-mini-profiler', require: false
  gem 'brakeman', require: false

  #helpers
  gem 'quiet_assets'
  gem 'escape_utils', '0.2.4', require: false

  # test tools
  gem 'database_cleaner', '>= 0.7.2', require: false
  gem 'factory_girl_rails', '>= 3.3.0'
  gem "ffaker", '~> 1.23.0'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'email_spec', '>= 1.2.1'
  gem 'launchy', '>= 2.1.0'
  gem 'spork', '0.9.2', require: false
end

group :development do
  gem 'capistrano', '~> 3.1.0'
  # rails specific capistrano funcitons
  gem 'capistrano-rails', '~> 1.1.0'
  # integrate bundler with capistrano
  gem 'capistrano-bundler'

  gem 'capistrano-rvm', github: "capistrano/rvm"
  # gem 'capistrano-rbenv', github: "capistrano/rbenv"
end

