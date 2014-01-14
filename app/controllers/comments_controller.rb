class CommentsController < ApplicationController
  before_action :set_comment, only: [:show,:edit,:update,:destroy]
  
  def create
    @comment = Comment.new(comment_params)
    @section = Section.find(params[:section_id])
    @comment.user_id = session[:user_id]
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @section, notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { redirect_to @section, notice: 'Invalid comment' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @section = Section.find(params[:section_id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @section }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body,:message_id)
    end
  
end
