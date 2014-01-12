class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :body
      t.string :type
      t.integer :resource
      t.integer :section_id
      t.integer :user_id

      t.timestamps
    end
  end
end
