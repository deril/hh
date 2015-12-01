class YAMLParser
  DATA_PATH = Rails.root + "public/content"
  CONTENT_FILE = DATA_PATH + 'result.yml'
  REJECT_SIZE = 40

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

    # TODO: may be rebase it into parse script
    def prepare(str)
      str.gsub(/[^\w\s]/, '').gsub(/_+/, '_').strip()
    end

    def make_array(str)
      prepared_str = prepare(str)
      array = prepared_str.strip.split(/\s+/)
      array.uniq.reject{|el| el.size > REJECT_SIZE || ['', ' ', '_'].include?(el) }
    end
end
