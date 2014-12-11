class TrayItemsController < ApplicationController
  def index
    render text: '403 Not Allowed', status: 403
  end

  # PUT /tray_items/1/move
  def move
    @tray_item = TrayItem.find params[ :id ]
    @tray = Tray.find params[ :tray_item ][ :tray_id ]

    @tray_item.tray = @tray
    @tray_item.save

    render text: '200 OK', status: 200
  end

  # POST /tray_items/1/copy
  def copy
    @tray_item = TrayItem.find params[ :id ]
    @tray = Tray.find params[ :tray_item ][ :tray_id ]

    TrayItem.create tray: @tray, image: @tray_item.image

    render text: '200 OK', status: 200
  end

  # DELETE /tray_items/1
  def destroy
    @tray_item = TrayItem.find params[ :id ]
    @tray_item.delete
    render text: '200 OK', status: 200
  end

end
