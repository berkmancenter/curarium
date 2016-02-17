class AddResourceNameToWorks < ActiveRecord::Migration
  def change
    add_column :works, :resource_name, :string
  end
end
