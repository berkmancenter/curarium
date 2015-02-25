class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.string :body
      t.references :activitiable, polymorphic: true, index: true

      t.integer :creator_id, index: true
      t.timestamps
    end
  end
end
