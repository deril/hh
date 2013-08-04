class Tag < ActiveRecord::Base
  attr_accessible :name, :count

  has_and_belongs_to_many :images
  belongs_to :group

  validates :name, presence: true

  # TODO: maybe group_id  get default val!
end