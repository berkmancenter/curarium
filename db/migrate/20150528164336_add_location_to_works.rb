class AddLocationToWorks < ActiveRecord::Migration
  def change
    add_column :works, :location, :geometry, geographic: true

    add_index :works, :location, using: :gist
  end
end
