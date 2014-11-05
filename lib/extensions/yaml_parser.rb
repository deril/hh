class YAMLParser
  DATA_PATH = Rails.root + "public/content"
  CONTENT_FILE = DATA_PATH + 'result.yml'

  def call()
    load_yaml_file().each do |sample|
      image = Image.new()               # FIXME: cannot find Image class as rake...
      add_content(image, sample)
      image.save!
    end
  end

  private
    def load_yaml_file
      YAML.load_file(CONTENT_FILE)
    end

    def add_image_file(image, file_name)
      file = File.new(DATA_PATH + file_name)
      image.image = file
      image
    end

    def add_tags(image, tags_str)
      tag_names = tags_str.split(/\s+/)
      tags = tag_names.inject([]) do |res, tag_name|

        # FIXME:
        # tag_name.strip.downcase.gsub(/\s+|_+/,' ').capitalize

        res << Tag.find_or_create_by!(name: tag_name)
      end
      image.tags = tags
      image
    end

    def add_warn(image, warn)
      warn = Warn.find_by!(name: warn)
      image.warn = warn
      image
    end

    def add_content(image, sample)
      add_image_file(image, sample[:image])
      add_tags(image, sample[:tags])
      add_warn(image, sample[:warn])
      image
    end
end
