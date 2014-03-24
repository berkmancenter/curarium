class AnnotationChangeContentType < ActiveRecord::Migration
  def change
    change_column :annotations, :content, 'json USING to_json(content) '
  end
end
