class MakeHashForAllImages < ActiveRecord::Migration
  def up
    Image.all.each do |image|
      image_hash = ImageToHash::HashMaker.make_hash(image.image)
      image.update_column(:image_hash, image_hash)
    end
  end
end
