class ChangeTitleTypeInWork < ActiveRecord::Migration
  def change
    change_column :works, :title, :text
  end
end
