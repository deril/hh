class AddIndexAndConditionIntoTagsTable < ActiveRecord::Migration
  def up
    change_column :tags, :name, :string, null: false
    add_index :tags, :group_id
  end

  def down
    change_column :tags, :name, :string, null: true
    remove_index :tags, :group_id
  end
end
