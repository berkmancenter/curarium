module TraysHelper
  # owner's name/title
  def tray_owner( owner )
    if owner.is_a? Circle
      owner.title
    else
      owner.name
    end
  end
  
  # path to a users or circles
  def x_trays_path( owner )
    if owner.is_a? Circle
      circle_trays_path owner
    else
      user_trays_path owner
    end
  end
  
  # path to a user or circle tray
  def x_tray_path( tray )
    if tray.owner_type == 'Circle'
      circle_tray_path tray.owner, tray
    else
      user_tray_path tray.owner, tray
    end
  end
  
  # path to a user or circle tray
  def new_x_tray_path( owner )
    if owner.is_a? Circle
      new_circle_tray_path owner
    else
      new_user_tray_path owner
    end
  end
  
  def include_target_class( tray, image_or_annotation_id )
    if tray.tray_items.where( 'image_id = ? OR annotation_id = ?', image_or_annotation_id, image_or_annotation_id ).count > 0
      'item-in'
    end
    'item-out'
  end
  
  def item_included_class( tray, item_type, item_id )
    if ( item_type == 'Image' && tray.has_image_id?( item_id ) ) || ( item_type == 'Annotation' && tray.has_annotation_id?( item_id ) )
      'list-group-item-info'
    else
      ''
    end
  end
end
