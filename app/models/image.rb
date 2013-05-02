class Image < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags

  attr_accessible :image_updated_at, :image, :tag_list
  has_attached_file :image, styles: { thumb: "180x180>" }, :default_url => "/images/:style/missing.png"

  paginates_per 10

# TODO: tests
  after_create :increment_count
  after_destroy :decrement_count
  before_update :update_count

  scope :desc, -> { order("id DESC") }

  validates_attachment :image, presence: true, 
                               content_type: { content_type: %w(image/jpeg image/png image/gif) },
                               size: { in: 0.5..30.megabytes }

  def rename_image!
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

  private
    def increment_count
      ActsAsTaggableOn::Tag.where(name: tag_list).update_all("count = count + 1")
    end

    def decrement_count
      ActsAsTaggableOn::Tag.where(name: tag_list).update_all("count = count - 1")
    end

    def update_count
      tags.update_all("count = count - 1")
      ActsAsTaggableOn::Tag.where(name: tag_list).update_all("count = count + 1")
    end

end