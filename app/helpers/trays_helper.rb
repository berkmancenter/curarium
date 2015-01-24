module TraysHelper
  
  # path to a user or circle tray
  def x_tray_path( tray )
    if tray.owner_type == 'Circle'
      circle_tray_path tray.owner, tray
    else
      user_tray_path tray.owner, tray
    end
  end
  
end
