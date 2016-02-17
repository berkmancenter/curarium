class AddCoverIdToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :cover_id, :integer
  end
end
