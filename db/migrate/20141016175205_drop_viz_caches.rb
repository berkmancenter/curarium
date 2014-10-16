class DropVizCaches < ActiveRecord::Migration
  def up
    drop_table :viz_caches
  end

  def down
    create_table :viz_caches do |t|
      t.text :query
      t.json :data

      t.timestamps
    end
  end
end
