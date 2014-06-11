class AddUniqueIdentifierToRecords < ActiveRecord::Migration
  def change
    add_column :records, :unique_identifier, :string
  end
end
