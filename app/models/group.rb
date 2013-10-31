class Group < ActiveRecord::Base
  attr_accessible :name, :parent, :parent_id

  has_many :tags
  belongs_to :parent, polymorphic: true

  validates :name,  presence: true,
                    uniqueness: true
end
