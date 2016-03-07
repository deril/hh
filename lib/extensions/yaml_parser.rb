class YAMLParser
  DATA_PATH = Rails.root + "public/content"
  CONTENT_FILE = DATA_PATH + 'result.yml'
  REJECT_MAX_SIZE = 40
  REJECT_MIN_SIZE = 3

  def call()
    load_yaml_file().each do |sample|
      image = Image.new()
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
      tag_names = make_array(tags_str)
      tags = tag_names.inject([]) do |res, tag_name|
        prepared_tag_name = Tag.prepare_name(tag_name)
        res << Tag.find_or_create_by!(name: prepared_tag_name)
      end
      image.tags = tags.uniq
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

    def prepare_string(str)
      prepared_str = str.downcase
      prepared_str.gsub!(/'|"|,/, '')
      prepared_str.gsub!(/-/, '_')
      prepared_str.gsub!(/\s+_|_\s+|\s+/, ' ')
      prepared_str
    end

    def make_array(str)
      prepared_str = prepare_string(str)
      array = prepared_str.split(' ').uniq
      array.uniq.reject{|el| el.size > REJECT_MAX_SIZE || el.size < REJECT_MIN_SIZE  }
    end
end
