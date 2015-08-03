class CreateCollectionFields < ActiveRecord::Migration
  def change
    create_table :collection_fields do |t|
      t.string :name
      t.string :display_name
      t.boolean :special
    end
  end
end
