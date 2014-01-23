class RemoveRecordsFromTray < ActiveRecord::Migration
  def change
    remove_column :trays, :records, :integer
  end
end
