class AddVisualizationsToTrays < ActiveRecord::Migration
  def change
    add_column :trays, :visualizations, :json, default: []
  end
end
