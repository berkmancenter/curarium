class AddPropertiesToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :properties, :json
  end
end
