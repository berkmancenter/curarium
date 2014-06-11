class AddSourceToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :source, :string
  end
end
