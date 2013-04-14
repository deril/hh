class DestoyTagsTable < ActiveRecord::Migration
  def up
    drop_table :tags
  end

  def down
    create_table :tags do |t|
      t.string :name, limit: '40', presence: true
      t.timestamps
    end
  end
end
