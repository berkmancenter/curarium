class AddCollectionsToCircle < ActiveRecord::Migration
  def change
    create_table :circle_collections do |t|
      t.belongs_to :circle
      t.belongs_to :collection

      t.timestamps
    end
  end
end
