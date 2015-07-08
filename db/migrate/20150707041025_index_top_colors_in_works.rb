class IndexTopColorsInWorks < ActiveRecord::Migration
  def up
    #execute %q[CREATE INDEX "index_works_on_top_colors" ON "works" ((json_array_elements(top_colors)->>'color'))]
  end

  def down
    #execute %q[DROP INDEX "index_works_on_top_colors"]
  end
end
