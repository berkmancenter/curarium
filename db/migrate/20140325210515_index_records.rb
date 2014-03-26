class IndexRecords < ActiveRecord::Migration
  def up
    execute %q[CREATE INDEX "index_records_on_title" ON "records" ((lower( "parsed"->'title')))]
  end

  def down
    execute %q[DROP INDEX "index_records_on_title"]
  end
end
