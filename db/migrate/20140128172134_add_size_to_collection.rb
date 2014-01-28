class AddSizeToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :size, :integer
  end
end
