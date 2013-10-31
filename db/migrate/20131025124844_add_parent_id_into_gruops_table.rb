class AddParentIdIntoGruopsTable < ActiveRecord::Migration
  def change
    add_column :groups, :parent_id, :integer, default: nil, after: :name
  end
end
