class CreateTrays < ActiveRecord::Migration
  def change
    create_table :trays do |t|
      t.integer :records
      t.references :owner, polymorphic: true

      t.timestamps
    end
  end
end
