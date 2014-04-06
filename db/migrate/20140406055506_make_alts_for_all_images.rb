class MakeAltsForAllImages < ActiveRecord::Migration
  def up
    Image.all.each do |image|
      alts = image.tags.sample.try(:name)
      p image.update_column(:alt, alts)
    end
  end
end
