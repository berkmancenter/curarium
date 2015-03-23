class AddImportingToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :importing, :boolean
  end
end
