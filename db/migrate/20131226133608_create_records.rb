class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.json :original
      t.hstore :parsed
      t.belongs_to :collection

      t.timestamps
    end
  end
end
