collection @trays
node(:owner_id) { |t| t.owner.id }
attributes :id, :name, :owner_id, :owner_type
child :tray_items do
  node(:type) { |ti|
    if ti.image.present?
      'Image'
    elsif ti.annotation.present?
      'Annotation'
    end
  }
  child :image do
    attributes :id, :image_url, :thumbnail_url, :work_id
    node(:work_title) { |i|
      i.work.title
    }
  end
  child :annotation do
    attributes :id, :title, :body, :x, :y, :width, :height, :thumbnail_url
    child :image do
      attributes :id, :image_url, :thumbnail_url, :work_id
      node(:work_title) { |i|
        i.work.title
      }
    end
  end
end

