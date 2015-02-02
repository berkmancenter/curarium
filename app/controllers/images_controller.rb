require 'open-uri'

class ImagesController < ApplicationController
  before_action :set_image, only: [ :show ]

  # GET /images/1
  def show
    # proxy the image through this app
  
    begin
      if @image.image_url.start_with?( '/test' ) && ( Rails.env.development? || Rails.env.test? )
        connection = File.open Rails.public_path.join( @image.image_url[ 1..-1 ] ), 'rb'
      else
        connection = open @image.image_url, 'rb'
      end
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

