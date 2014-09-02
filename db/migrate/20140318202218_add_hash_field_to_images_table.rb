class AddHashFieldToImagesTable < ActiveRecord::Migration
  def change
    add_column :images, :image_hash, :string, limit: 1024, defauld: nil
  end
end
