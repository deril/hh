class ImagesTag < ActiveRecord::Base

  belongs_to :image
  belongs_to :tag, counter_cache: :count

end
