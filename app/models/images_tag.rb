class ImagesTag < ActiveRecord::Base

  # TODO: test it 
  belongs_to :image
  belongs_to :tag

  accepts_nested_attributes_for :tag 

end