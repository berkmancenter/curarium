class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy, :message]
  before_action :is_member, only: [:show]

  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
    @s = Section.find(params[:id])
  end

  # GET /sections/new
  def new
    @section = Section.new
    @user = User.find(session[:user_id])
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)
    #populate users array
    users = []   #create placeholder array
    params[:users].each do |key, value|
      unless users.include? value.to_i
        users.push(value.to_i) #populate placeholder array with the value of the :users parameter, which is sadly a Hash.
      end
    end    
    @user = User.find(session[:user_id]) #find the current user, who will be the administrator of the section
    @section.admins = [@user.id] #admins is an array, hence the brackets
    if not users.include? session[:user_id]
      users.push(@user.id) #add the admin to the users array if it is not already in it
    end
    @section.users = users #assign the users array to @section.users
    resources = params[:resources] #retrieve the :resources param, which is a bunch of nested hashes
    resources.each do |key, value|
      resources[key] = value.values #parse :resources so that it becomes one hash with many arrays
    end
    @section.resources = resources #assigned parsed :resources to @section.resources
    
    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render action: 'show', status: :created, location: @section }
      else
        format.html { render action: 'new' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to @section, notice: 'Section was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url }
      format.json { head :no_content }
    end
  end
  
  def message
    @message = {}
    @message[:sender] = User.find(params[:message][:sender])
    @message[:members] = []
    @section.users.each do |member_id|
      if member_id != session[:user_id]
        @message[:members].push(User.find(member_id))
      end
    end
    @message[:subject] = params[:message][:subject]
    @message[:content] = params[:message][:content]
    UserMailer.section_message(@message).deliver
    redirect_to @section
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    def is_member
      unless @section.users.include?(session[:user_id].to_i) || @section.users.include?(session[:user_id].to_s)
        redirect_to root_url, notice: 'you are not part of this group'
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:admins, :title)
    end
end
