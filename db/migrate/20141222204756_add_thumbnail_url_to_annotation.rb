class AddThumbnailUrlToAnnotation < ActiveRecord::Migration
  def change
    add_column :annotations, :thumbnail_url, :string
  end
end
