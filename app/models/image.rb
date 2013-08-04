class Image < ActiveRecord::Base

  # TODO: DELETE taggable table

  attr_accessible :image_updated_at, :image, :tag_list
  has_attached_file :image, styles: { thumb: "180x180>", medium: "600x600>" }, 
                            default_url: "/images/:style/missing.png"

  has_and_belongs_to_many :tags
  paginates_per 50

  # TODO: tests
  after_create :increment_count
  after_destroy :decrement_count
  before_update :update_count

  scope :desc, -> { order("id DESC") }

  validates_attachment :image, presence: true, 
                               content_type: { content_type: %w(image/jpeg image/png image/gif) },
                               size: { in: 0.5..50.megabytes }

  def rename_image!
    return if self.image_file_name.blank?
    extension = File.extname(self.image_file_name).downcase
    name = image_updated_at.to_i.to_s
    self.image_file_name = 'HH_' + name + extension
  end

  # TODO: tests
  def save_with_response
    if save
      { notice: "Image saved successfully." }
    else
      { alert: "Image saving failed." }
    end
  end

  # TODO: tests
  def destroy_with_response
    if destroy
      { notice: "Image deleted successfully." }
    else
      { alert: "Image deleting failed." }
    end
  end

  # TODO: tests
  def get_dimensions
    Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image))
  end

  # TODO: tests
  def get_adapted_size
    if image_file_size/1024/1024 > 0
      "#{image_file_size/1024/1024} Mb"
    else
      "#{image_file_size/1024} Kb"
    end
  end

  private
    def increment_count
      ActsAsTaggableOn::Tag.where(name: tag_list).update_all("count = count + 1")
    end

    def decrement_count
      ActsAsTaggableOn::Tag.where(name: tag_list).update_all("count = count - 1")
    end

    def update_count
      tags.update_all("count = count - 1")
      increment_count
    end
end