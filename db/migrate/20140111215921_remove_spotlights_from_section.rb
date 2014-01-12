class RemoveSpotlightsFromSection < ActiveRecord::Migration
  def change
    remove_column :sections, :spotlights, :integer
    remove_column :sections, :trays, :integer
  end
end
