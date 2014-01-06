class CreateWarnsTable < ActiveRecord::Migration
  def change
    create_table :warns do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end

