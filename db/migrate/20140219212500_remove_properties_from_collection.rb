class RemovePropertiesFromCollection < ActiveRecord::Migration
  def up
    remove_column :collections, :properties, :json
  end

  def down
    add_column :collections, :properties, :json
  end
end
