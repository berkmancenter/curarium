class AddSuperToUser < ActiveRecord::Migration
  def change
    add_column :users, :super, :boolean, default: false
  end
end
