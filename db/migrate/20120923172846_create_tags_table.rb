class CreateTagsTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, limit: '40', presence: true
      t.timestamps
    end
  end
end
