class AddNameToTray < ActiveRecord::Migration
  def change
    add_column :trays, :name, :string
  end
end
