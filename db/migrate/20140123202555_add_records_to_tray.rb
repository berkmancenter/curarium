class AddRecordsToTray < ActiveRecord::Migration
  def change
    add_column :trays, :records, :integer, array: true, default: []
  end
end
