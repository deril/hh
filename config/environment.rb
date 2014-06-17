# Load the rails application
require File.expand_path('../application', __FILE__)

Rails.application.initialize!

APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")