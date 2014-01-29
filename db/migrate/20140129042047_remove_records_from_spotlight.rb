class RemoveRecordsFromSpotlight < ActiveRecord::Migration
  def change
    remove_column :spotlights, :records, :integer
  end
end
