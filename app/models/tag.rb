class Tag < ActiveRecord::Base
  attr_accessible :name, :count

  has_many :images_tags, dependent: :destroy
  has_many :images, through: :images_tags
  belongs_to :group

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
end