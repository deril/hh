class Warn < ActiveRecord::Base

  # FIXME remove mass assign
  # attr_accessible :name

  has_many :images

  validates :name, presence: true

end
