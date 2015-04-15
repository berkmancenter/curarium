class AddColorsToWorks < ActiveRecord::Migration
  def change
    add_column :works, :primary_color, :string
    add_column :works, :top_colors, :json
  end
end
