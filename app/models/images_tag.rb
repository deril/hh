class ImagesTag < ActiveRecord::Base

  belongs_to :image
  belongs_to :tag

  accepts_nested_attributes_for :tag 

end