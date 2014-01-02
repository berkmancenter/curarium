class AddAssociationsToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :associations, :json
  end
end
