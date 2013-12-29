class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.string :key
      t.text :description
      t.boolean :approved
      t.json :configuration

      t.timestamps
    end
  end
end
