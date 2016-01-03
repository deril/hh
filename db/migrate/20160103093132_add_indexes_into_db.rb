class AddIndexesIntoDb < ActiveRecord::Migration
  def change
    add_index :images, :warn_id
    add_index :images_tags, :tag_id
    add_index :images_tags, :image_id
    add_index :tags, :group_id
    add_index :groups, :group_id
  end
end
