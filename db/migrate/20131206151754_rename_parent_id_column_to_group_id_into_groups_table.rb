class RenameParentIdColumnToGroupIdIntoGroupsTable < ActiveRecord::Migration
  def change
    rename_column :groups, :parent_id, :group_id
  end
end
