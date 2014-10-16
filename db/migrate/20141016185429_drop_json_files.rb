class DropJsonFiles < ActiveRecord::Migration
  def up
    drop_table :json_files
  end

  def down
    create_table :json_files do |t|
      t.string   :path
      t.integer  :collection_id
    end
  end
end
