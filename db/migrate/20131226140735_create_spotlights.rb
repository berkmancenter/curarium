class CreateSpotlights < ActiveRecord::Migration
  def change
    create_table :spotlights do |t|
      t.string :title
      t.text :body
      t.string :type
      t.integer :records, array: true, default: []

      t.timestamps
    end
  end
end
