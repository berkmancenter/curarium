collection @trays
attributes :id, :name, :owner_id, :owner_type
child :tray_items do
  child :image do
    attributes :id, :image_url, :thumbnail_url, :work_id
  end
  child :annotation do
    attributes :id
  end
end

