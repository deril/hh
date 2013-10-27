class Group < ActiveRecord::Base
  attr_accessible :name

  has_many :tags
  belongs_to :parent, polymorphic: true

  validates :name,  presence: true,
                    uniqueness: true
end
