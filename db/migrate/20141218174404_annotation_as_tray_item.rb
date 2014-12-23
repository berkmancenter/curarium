class AnnotationAsTrayItem < ActiveRecord::Migration
  def change
    add_reference :tray_items, :annotation, index: true
    add_reference :annotations, :tray_item, index: true
  end
end
