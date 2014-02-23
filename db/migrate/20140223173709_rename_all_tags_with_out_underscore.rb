class RenameAllTagsWithOutUnderscore < ActiveRecord::Migration
  def up
    Tag.all.each do |tag|
      tag.name = tag.name.humanize
      tag.save!
    end
  end

  def down
    Tag.all.each do |tag|
      tag.name = tag.name.underscore
      tag.save!
    end
  end
end
