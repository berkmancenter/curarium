class CreateJsonFiles < ActiveRecord::Migration
  def change
    create_table :json_files do |t|
      t.string :path
      t.references :collection, index: true

      t.timestamps
    end
  end
end
