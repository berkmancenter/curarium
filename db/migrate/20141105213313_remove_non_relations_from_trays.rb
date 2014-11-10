class RemoveNonRelationsFromTrays < ActiveRecord::Migration
  def change
    remove_column :trays, :works, :integer, array: true, default: []
    remove_column :trays, :visualizations, :json, default: []
  end
end
