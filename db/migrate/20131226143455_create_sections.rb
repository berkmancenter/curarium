class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :users
      t.string :admins
      t.integer :spotlights, array: true, default: []
      t.integer :trays, array: true, default: []

      t.timestamps
    end
  end
end
