module TraysHelper
  
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
  
end
