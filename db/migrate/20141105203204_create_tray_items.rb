class CreateTrayItems < ActiveRecord::Migration
  def change
    create_table :tray_items do |t|
      t.references :tray, index: true
      t.references :image, index: true

      t.timestamps
    end

    add_reference :images, :tray_item, index: true
  end
end
