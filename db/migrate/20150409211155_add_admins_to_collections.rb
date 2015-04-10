class AddAdminsToCollections < ActiveRecord::Migration
  def change
    remove_column :collections, :admin, :integer, array: true, default: []

    create_table :collection_admins, id: false do |t|
      t.belongs_to :collection, index: true
      t.belongs_to :user, index: true
    end
  end
end
