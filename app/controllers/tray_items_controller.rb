class TrayItemsController < ApplicationController
  def index
    render text: '403 Not Allowed', status: 403
  end

  def move
    @tray_item = TrayItem.find params[ :id ]
    @tray = Tray.find params[ :tray_id ]

    @tray_item.tray = @tray
    @tray_item.save

    render text: '200 OK', status: 200
  end

  def copy
    @tray_item = TrayItem.find params[ :id ]
    @tray = Tray.find params[ :tray_id ]

    TrayItem.create tray: @tray, image: @tray_item.image

    render text: '200 OK', status: 200
  end
end
