class Image < ActiveRecord::Base

  # TODO: make constants of saving/deleting responses !!!! and may be new class for them
  # attr_accessible :image_updated_at, :image, :tags, :image_file_size, :images_tags, :tag_ids, :warn_id

  has_attached_file :image,
    styles: { thumb: "180x180#", medium: "600x600>" },
    default_url: "/images/:style/missing.png"

  has_many :images_tags, dependent: :destroy
  has_many :tags, through: :images_tags
  belongs_to :warn

  accepts_nested_attributes_for :images_tags

  paginates_per 32

  before_create :rename_image!

  scope :desc, -> { order("id DESC") }

  validates_attachment :image, presence: true,
                               content_type: { content_type: %w(image/jpeg image/png image/gif) },
                               size: { in: 0.5..50.megabytes }

  def rename_image!
    return if self.image_file_name.blank?
    extension = File.extname(self.image_file_name).downcase
    name = image_updated_at.to_i.to_s
    self.image_file_name = 'hentaria_' + name + extension
  end

  def self.not_found
    { alert: "Can't find such Image." }
  end

  def save_with_response
    if save
      { notice: "Image saved successfully." }
    else
      { alert: "Image saving failed." }
    end
  end

  def destroy_with_response
    if destroy
      { notice: "Image deleted successfully." }
    else
      { alert: "Image deleting failed." }
    end
  end
  
  def get_dimensions
    Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image))
  end

  def get_adapted_size
    if image_file_size/1024/1024 > 0
      "#{image_file_size/1024/1024} Mb"
    else
      "#{image_file_size/1024} Kb"
    end
  end

end
