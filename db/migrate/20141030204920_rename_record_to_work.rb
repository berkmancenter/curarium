class RenameRecordToWork < ActiveRecord::Migration
  def change
    rename_table :records, :works
  end
end
