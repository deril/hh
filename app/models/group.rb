class Group < ActiveRecord::Base

  has_many :tags, dependent: :nullify
  belongs_to :parent, class_name: "Group", foreign_key: "group_id"
  has_many :children, class_name: "Group", foreign_key: "group_id"


  validates :name,  presence: true,
                    uniqueness: true

  scope :parents_only, -> { where(group_id: nil) }

end
