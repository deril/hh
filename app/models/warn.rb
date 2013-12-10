class Warn < ActiveRecord::Base
  attr_accessible :name
  
  has_many :images

  validates :name, presence: true
end