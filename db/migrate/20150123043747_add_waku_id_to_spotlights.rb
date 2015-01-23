class AddWakuIdToSpotlights < ActiveRecord::Migration
  def change
    add_column :spotlights, :waku_id, :integer
  end
end
