class CreateAmendments < ActiveRecord::Migration
  def change
    create_table :amendments do |t|
      t.hstore :previous
      t.hstore :amended
      t.references :user, index: true
      t.references :record, index: true

      t.timestamps
    end
  end
end
