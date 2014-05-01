class AnnotationChangeContentType < ActiveRecord::Migration
  def change
    remove_column :annotations, :content, :integer
    add_column :annotations, :content, :json
  end
end
