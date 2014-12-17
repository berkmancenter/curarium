class UpdateAnnotation < ActiveRecord::Migration
  def change
    remove_column :annotations, :work_id, :integer
    add_reference :annotations, :image, index: true

    remove_column :annotations, :content, :hstore
    add_column :annotations, :title, :string
    add_column :annotations, :tags, :string
    add_column :annotations, :body, :text

    add_column :annotations, :x, :integer
    add_column :annotations, :y, :integer
    add_column :annotations, :width, :integer
    add_column :annotations, :height, :integer

    add_column :annotations, :image_url, :string
  end
end
