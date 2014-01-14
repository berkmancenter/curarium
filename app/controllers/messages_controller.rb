class MessagesController < ApplicationController
  before_action :set_message, only: [:show,:edit,:update,:destroy]
  
  def show
    render json: @message
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @section = Section.find(params[:section_id])
    @message = Message.new(message_params)
    @message.user_id = session[:user_id]
    @message.section_id = @section.id
    respond_to do |format|
      if @message.save
        format.html { redirect_to @section, notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @section = Section.find(params[:section_id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to @section }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:title,:body)
    end
  
end
