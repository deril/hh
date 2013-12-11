class AddWarnsIdFieldIntoImagesTable < ActiveRecord::Migration
  def change
    add_column :images, :warn_id, :integer, default: nil
  end
end
