class ChangeWakuIdToStringOnSpotlights < ActiveRecord::Migration
  def change
    change_column :spotlights, :waku_id, :string
  end
end
