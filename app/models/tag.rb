class Tag < ActiveRecord::Base

  has_many :images_tags, dependent: :destroy
  has_many :images, through: :images_tags
  belongs_to :group

  before_save { self.name = prepare_name() }

  default_scope { order(name: :asc) }
  scope :null_group, -> { where(group_id: nil) }

  validates :name,  presence: true,
                    uniqueness: true

  def self.prepare_name(tag_name)
    tag_name.strip.downcase.gsub(/\s+|_+/,' ').capitalize
  end

  def prepare_name
    Tag.prepare_name(self.name)
  end

  def save_with_response
    if save
      { notice: "Tag successfully Saved." }
    else
      { alert: "Something bad with tag Saving." }
    end
  end

  def destroy_with_response
    if destroy
      { notice: "Tag successfully Deleted." }
    else
      { alert: "Something bad with tag Deleting." }
    end
  end

  # FIXME: deprecated
  def self.not_found
    { alert: "Can't find such Tag." }
  end
end
