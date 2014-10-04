class AddThumbnailUrlToRecord < ActiveRecord::Migration
  def change
    add_column :records, :thumbnail_url, :string
  end
end
