class AddComponentsToSpotlight < ActiveRecord::Migration
  def change
    add_column :spotlights, :components, :json
  end
end
