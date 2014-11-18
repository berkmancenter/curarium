class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :super?, only: [:index]
  skip_before_action :authorize, only: [:new, :create]
  skip_before_filter :verify_authenticity_token #this must be deleted!~

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new( user_params )
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if params[ 'send_secret' ] == 'y'
      ActionMailer::Base.mail(:from => 'curarium@metalab.harvard.edu', :to => params[ :email ], :subject => 'Curarium beta secret word', :body => 'The secret word needed to create a beta account is: Berenson2014').deliver

      @user = User.new(user_params)
      render :new
    else
      @user = User.new(user_params)

      if params[ :magic_word ] == 'Berenson2014' && @user.save
        redirect_to login_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def message
    @message = {}
    @message[:sender] = User.find(params[:message][:sender])
    @message[:receiver] = User.find(params[:message][:receiver])
    @message[:subject] = params[:message][:subject]
    @message[:content] = params[:message][:content]
    UserMailer.personal_message(@message).deliver
    redirect_to @message[:receiver]
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation) unless params[ :user ].nil?
  end
  
  def super?
    unless User.find(session[:user_id]).super
      redirect_to root_path
    end
  end
  
end
