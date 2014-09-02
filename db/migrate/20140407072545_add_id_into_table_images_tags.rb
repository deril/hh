class AddIdIntoTableImagesTags < ActiveRecord::Migration
  def change
    add_column :images_tags, :id, :primary_key
  end
end
