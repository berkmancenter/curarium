class RenameRecordRelations < ActiveRecord::Migration
  def self.up
    rename_column :amendments, :record_id, :work_id

    rename_column :annotations, :record_id, :work_id
    
    rename_column :trays, :records, :works
  end

  def self.down
    rename_column :trays, :works, :records

    rename_column :annotations, :work_id, :record_id

    rename_column :amendments, :work_id, :record_id
  end
end
