require 'trays_helper'

class TraysController < ApplicationController
  before_action :set_owner
  before_action :set_tray, only: [ :show, :edit, :update, :destroy ]
  before_action :set_trays, only: [ :index, :show ]

  def index
    response.headers[ 'Access-Control-Allow-Origin' ] = Waku::CORS_URL
    if authenticated?
      if @owner.is_a?( Circle ) ? @owner.has_user?( @current_user ) : @current_user == @owner
        respond_to { |format|
          format.html {
            if request.xhr?
              @popup_action = params[ 'popup_action' ]
              @popup_action_type = params[ 'popup_action_item_type' ]
              @popup_action_item_id = params[ 'popup_action_item_id' ]
              render 'popup', layout: false
            else
              render
            end
          }
          format.any( :xml, :json ) {
            render
          }
        }
      else
        render text: '403 Forbidden', status: 403
      end
    else
      response.headers[ 'WWW-Authenticate' ] = 'Negotiate'
      render text: '401 Unauthroized', status: 401
    end
  end
  
  def show
  end
  
  def new
    @tray = Tray.new owner_type: @owner_type, owner_id: @owner.id
  end
    
  def create
    @tray = Tray.create(tray_params)

    if request.xhr?
      @trays = @owner.trays
      @popup_action = params[ 'popup_action' ]
      @popup_action_type = params[ 'popup_action_item_type' ]
      @popup_action_item_id = params[ 'popup_action_item_id' ]
      render 'popup', layout: false
    else
      redirect_to view_context.x_trays_path( @owner )
    end

  end
  
  # DELETE /trays/1
  def destroy
    @tray.delete
    render text: '200 OK', status: 200
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tray
    @tray = Tray.find(params[:id])
  end

  def set_owner
    if params[ :user_id ].present?
      @owner = User.friendly.find( params[ :user_id ] )
    elsif params[ :circle_id ].present?
      @owner = Circle.find( params[ :circle_id ] )
    else
      @owner = @current_user
    end
    @owner_type = @owner.class.to_s
  end

  def set_trays
    if @owner.present?
      if @owner.is_a? Circle
        @trays = @owner.trays
      else # User + Circle trays
        @trays = @owner.all_trays
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tray_params
    params.require(:tray).permit(:name, :owner_id, :owner_type) #, visualizations:[:url, terms:[:type,:property,:length]])
  end

end
