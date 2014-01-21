class AddAnnotationsToSpotlight < ActiveRecord::Migration
  def change
    add_column :spotlights, :annotations, :integer, array: true, default: []
  end
end
