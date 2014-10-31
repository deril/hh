require 'yaml'

# IN TEST PURPOUSES
namespace :parsed do

  DATA_PATH = Rails.root + "public/content"
  CONTENT_FILE = DATA_PATH + '/result.yml'

  # TODO: tests
  # TODO: add logs & outputs
  desc 'Fill up db with parsed content.'
  task :populate do
    return false unless content_folder_exist?(DATA_PATH)
    return false if content_folder_empty?(DATA_PATH)

    content = YAML.load_file(CONTENT_FILE)
    content.each do |sample|
      image = Image.new()
      add_content(image, sample)
      image.save!
    end
    p 'Done.'
  end

  private

    def content_folder_exist?(path)
      return true if Dir.exists?(path)
      p 'Content folder does not exists.'
      return false
    end

    def content_folder_empty?(path)
      return false if Dir[path + '/*'].empty?
      p 'Content folder is empty.'
      return true
    end

    def add_tags(image, tags_str)
      tag_names = tags_str.split(/\s/)
      tags = tag_names.inject([]) do |res, tag_name|
        res << Tag.find_or_create_by!(name: tag_name)
      end
      image.tags = tags
    end

    def add_warn(image, warn)
      warn = Warn.find_by!(name: warn)
      image.warn = warn
    end

    def add_image_file(image, file_name)
      file = File.new(DATA_PATH + '/' + file_name)
      image.image = file
    end

    def add_content(image, sample)
      add_image_file(image, sample[:image])
      add_tags(image, sample[:tags])
      add_warn(image, sample[:warn])
      image
    end
end
