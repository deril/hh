class AddAltToImages < ActiveRecord::Migration
  def change
    add_column :images, :alt, :string
  end
end
