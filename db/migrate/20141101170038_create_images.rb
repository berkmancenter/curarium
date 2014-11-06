class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :image_url
      t.text :thumbnail_url
      t.references :work, index: true

      t.timestamps
    end
  end
end
