source 'https://rubygems.org'

gem 'rails', '4.1.5'

gem 'mysql2'
gem 'kaminari'
gem 'haml', '~> 4.0.5'
gem 'rmagick', '2.13.2'
gem 'execjs'
gem "paperclip", "~> 4.1"
gem 'metamagic'
gem 'devise'
gem 'timecop'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails', '~> 4.0.3'

# gem 'turbolinks'          # TODO: think about it
# gem 'jbuilder', '~> 1.2'  # TODO: think about it

gem 'coffee-rails', '~> 4.0.0'
gem 'compass', '>= 0.12.2'
gem 'compass-rails', '>= 1.0.3'
gem 'susy'
gem 'uglifier', '>= 1.3.0'
gem 'formtastic'
gem 'sitemap_generator'
# gem 'whenever', :require => false TODO: when we'll deploy rare, can generate sitemap

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :test do
  gem 'thin', require: false
  gem 'simplecov', require: false
  gem 'rspec-rails'

  gem 'shoulda-matchers'
  gem 'factory_girl_rails', '>= 3.3.0'
  gem 'cucumber-rails', '>= 1.3.0', :require => false
  gem 'escape_utils', '0.2.4', require: false
  gem 'capybara'
  gem 'database_cleaner', '>= 0.7.2', require: false
  gem 'email_spec', '>= 1.2.1'
  gem 'launchy', '>= 2.1.0'
  gem 'spork', '0.9.2', require: false
  gem "parallel_tests", "0.6.17"
  gem "ffaker", '~> 1.23.0'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

group :development do
  gem 'capistrano', '~> 3.1.0'
  # rails specific capistrano funcitons
  gem 'capistrano-rails', '~> 1.1.0'
  # integrate bundler with capistrano
  gem 'capistrano-bundler'

  gem 'capistrano-rvm', github: "capistrano/rvm"
end

# To use debugger
# gem 'debugger'
