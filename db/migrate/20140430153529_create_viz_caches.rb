class CreateVizCaches < ActiveRecord::Migration
  def change
    create_table :viz_caches do |t|
      t.text :query
      t.json :data

      t.timestamps
    end
  end
end
