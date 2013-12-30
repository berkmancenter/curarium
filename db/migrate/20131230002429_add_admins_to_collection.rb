class AddAdminsToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :admin, :integer, array: true, default: []
  end
end
