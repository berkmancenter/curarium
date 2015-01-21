class SupportWakuSpotlights < ActiveRecord::Migration
  def change
    remove_column :spotlights, :components, :json
    remove_column :spotlights, :type, :string
    add_column :spotlights, :waku_url, :string
  end
end
