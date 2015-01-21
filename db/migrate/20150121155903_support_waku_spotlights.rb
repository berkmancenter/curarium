class SupportWakuSpotlights < ActiveRecord::Migration
  def change
    remove_column :spotlights, :components, :json
    add_column :spotlights, :waku_url, :string
  end
end
