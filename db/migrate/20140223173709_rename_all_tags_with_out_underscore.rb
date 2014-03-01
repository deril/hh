class RenameAllTagsWithOutUnderscore < ActiveRecord::Migration
  def up
    p 'updating tags names'
    Tag.all.each do |tag|
      p tag.update_columns(name: tag.name.humanize)
    end
    p 'done...'
  end

  def down
    p 'updating tags names back'
    Tag.all.each do |tag|
      p tag.update_columns(name: tag.name.gsub(/\s+/, '_'))
    end
    p 'done...'
  end
end
