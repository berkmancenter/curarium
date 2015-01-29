class TrayItemsController < ApplicationController
  def index
    render text: '403 Not Allowed', status: 403
  end

  # PUT /tray_items/1/move
  def move
    @tray_item = TrayItem.find params[ :id ]
    @tray = Tray.find tray_item_params[ :tray_id ]

    @tray_item.tray = @tray
    @tray_item.save

    render text: '200 OK', status: 200
  end

  # POST /tray_items
  # adds or removes an item from the tray
  def create
    tip = tray_item_params
    @tray = Tray.find tip[ :tray_id ]
    if @tray.has_image_id?( tip[ :image_id ] )
      @tray.tray_items.where( image_id: tip[ :image_id ] ).delete_all
    else
      @tray_item_image = Image.find tip[ :image_id ]
      TrayItem.create tray: @tray, image: @tray_item_image
    end

    render text: '200 OK', status: 200
  end
  
  # POST /tray_items/1/copy
  def copy
    @tray_item = TrayItem.find params[ :id ]
    @tray = Tray.find tip[ :tray_id ]

    TrayItem.create tray: @tray, image: @tray_item.image

    render text: '200 OK', status: 200
  end

  # DELETE /tray_items/1
  def destroy
    @tray_item = TrayItem.find params[ :id ]
    @tray_item.delete
    render text: '200 OK', status: 200
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tray_item_params
    params.require(:tray_item).permit(:tray_id, :image_id, :annotation_id)
  end

end
