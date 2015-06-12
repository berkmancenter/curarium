class AddCoverIdToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :cover_id, :integer
  end
end
