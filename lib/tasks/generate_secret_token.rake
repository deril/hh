require 'securerandom'

namespace :secret_token do
  desc 'Generates secret token'
  task :generate do

    token_file = Rails.root.join('.secret')
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
    p 'Done'

  end
end

