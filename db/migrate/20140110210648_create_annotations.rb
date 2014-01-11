class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.integer :user_id
      t.integer :record_id
      t.hstore :content

      t.timestamps
    end
  end
end
