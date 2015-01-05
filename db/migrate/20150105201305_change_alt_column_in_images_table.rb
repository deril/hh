class ChangeAltColumnInImagesTable < ActiveRecord::Migration
  def up
    Image.all.each do |image|
      image.add_alt!
      image.save!
    end
  end

  def down
    # irreversible
  end
end
