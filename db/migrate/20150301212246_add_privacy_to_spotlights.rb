class AddPrivacyToSpotlights < ActiveRecord::Migration
  def change
    add_column :spotlights, :privacy, :string, default: 'private'
  end
end
