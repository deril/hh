# IN TEST PURPOUSES

require Rails.root + 'lib/extensions/yaml_parser'

namespace :parsed do
  desc 'Fill up db with parsed content.'
  task populate: :environment do
    ActiveRecord::Base.transaction do
      if content_folder_prepaed(YAMLParser::DATA_PATH)
        YAMLParser.new().call()
        p 'Done.'
      end
    end
  end

  private
    def content_folder_prepaed(path)
      content_folder_exist?(path) && content_folder_not_empty?(path)
    end

    def content_folder_exist?(path)
      return true if Dir.exists?(path)
      p 'Content folder does not exists.'
      return false
    end

    def content_folder_not_empty?(path)
      return true unless Dir[path + '/*'].empty?
      p 'Content folder is empty.'
      return false
    end
end
