class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.string :title
      t.string :description
      t.integer :admin_id, index: true

      t.timestamps
    end

    create_table :circles_users, id: false do |t|
      t.belongs_to :circle, index: true
      t.belongs_to :user, index: true
    end
  end
end
