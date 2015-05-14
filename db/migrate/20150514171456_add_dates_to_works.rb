class AddDatesToWorks < ActiveRecord::Migration
  def change
    add_column :works, :datestart, :datetime
    add_column :works, :dateend, :datetime
  end
end
