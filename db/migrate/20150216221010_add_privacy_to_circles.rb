class AddPrivacyToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :privacy, :string, default: 'private'
  end
end
