class CreateTagsTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, limit: '40', presence: true
      t.integer :count, default: 0
      t.integer :group_id
      t.timestamps
    end
    create_table :images_tags, :id => false do |t|
      t.references :tag
      t.references :image
    end
  end
end
