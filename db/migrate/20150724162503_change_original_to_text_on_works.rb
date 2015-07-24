class ChangeOriginalToTextOnWorks < ActiveRecord::Migration
  def change
    change_column :works, :original, :text
  end
end
