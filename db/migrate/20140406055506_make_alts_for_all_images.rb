class MakeAltsForAllImages < ActiveRecord::Migration
  def up
    Image.all.each do |image|
      alts = image.tags.sample(5).map(&:name).join(', ')
      p image.update_column(:alt, alts)
    end
  end
end
