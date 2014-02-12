class Tag < ActiveRecord::Base
  # FIXME remove mass assign
  # attr_accessible :name, :count, :group_id

  has_many :images_tags, dependent: :destroy
  has_many :images, through: :images_tags
  belongs_to :group

  # TODO: if group was deleted do we need to clear field group_id???

  validates :name,  presence: true,
                    uniqueness: true

  # TODO: maybe group_id  get default val!

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

  def self.not_found
    { alert: "Can't find such Tag." }
  end
end
