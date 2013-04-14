class DestoyImagesTagsTable < ActiveRecord::Migration
  def up
    drop_table :images_tags
  end

  def down
    create_table :images_tags do |t|
      t.integer :image_id
      t.integer :tag_id
      t.timestamps
    end
  end
end
