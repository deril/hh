class Warn < ActiveRecord::Base
  has_many :images
  validates :name, presence: true
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
