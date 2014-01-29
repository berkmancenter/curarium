class RemoveAnnotationsFromSpotlight < ActiveRecord::Migration
  def change
    remove_column :spotlights, :annotations, :integer
  end
end
