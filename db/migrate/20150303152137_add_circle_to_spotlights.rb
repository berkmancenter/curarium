class AddCircleToSpotlights < ActiveRecord::Migration
  def change
    add_reference :spotlights, :circle, index: true
  end
end
