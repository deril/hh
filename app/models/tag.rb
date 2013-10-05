class Tag < ActiveRecord::Base
  attr_accessible :name, :count

  has_and_belongs_to_many :images
  belongs_to :group

  validates :name,  presence: true, 
                    uniqueness: true

  # TODO: maybe group_id  get default val!

  # TODO: test it
  def save_with_response
    if save
      { notice: "Tag successfully Saved." }
    else
      { alert: "Somthing bad with tag Saving." }
    end
  end

  def destroy_with_response
    if destroy
      { notice: "Tag successfully Deleted." }
    else
      { alert: "Somthing bad with tag Deleting." }
    end
  end

end