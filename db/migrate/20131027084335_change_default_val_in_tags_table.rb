class ChangeDefaultValInTagsTable < ActiveRecord::Migration
  def up 
    change_column :tags, :group_id, :integer, default: nil
  end

  def down
    change_column :tags, :group_id, :integer, default: 0
  end
end
