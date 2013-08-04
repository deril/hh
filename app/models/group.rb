class Group < ActiveRecord::Base
  attr_accessible :name

  has_many :tags

  validates :name, presence: true
end
