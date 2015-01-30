require 'open-uri'

class ImagesController < ApplicationController
  before_action :set_image, only: [ :show ]

  # GET /images/1
  def show
    # proxy the image through this app
  
    begin
      #connection = open @image.image_url, 'rb'
      connection = open 'http://upload.wikimedia.org/wikipedia/commons/7/73/Eris_Antikensammlung_Berlin_F1775.jpg', 'rb'
    rescue Net, OpenURI::HTTPError => e
      connection = nil
    end

    if connection.present?
      send_data connection.read, disposition: :inline, type: 'image/jpeg'
    else
      render nothing: true, status: 404, content_type: 'image/jpeg'
    end
  end



  private

  def set_image
    @work = Work.find(params[:work_id])
    @image = @work.images[ params[:index].to_i - 1 ]
  end
end

