class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :users, array: true, default: []
      t.integer :admins, array: true, default: []
      t.integer :spotlights, array: true, default: []
      t.integer :trays, array: true, default: []

      t.timestamps
    end
  end
end
