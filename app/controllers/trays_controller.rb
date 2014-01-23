class TraysController < ApplicationController
  before_action :set_tray, only: [:show, :edit, :update, :destroy, :add_records]
  
  def show
    render json: @tray
  end
  
  def add_records
    old_records = @tray.records
    request_records = params[:records]
    new_records = []
    request_records.each do |r|
      new_records.push(r.to_i)
    end
    new_records.each do |r|
      puts r.class
    end
    @tray.records = (old_records+new_records).uniq
    @tray.save
    render json: @tray
  end
  
  def new
    @tray = Tray.new
    if params.include? :section_id
      @owner = Section.find(params[:section_id])
    else
      @owner = User.find(params[:user_id])
    end
  end
    
  def create
    @tray = Tray.new(tray_params)
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tray
      @tray = Tray.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tray_params
      params.require(:tray).permit(:title, :body, :type, :records)
    end
  
end
