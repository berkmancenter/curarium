class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :thumb, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:show]

  # GET /records
  # GET /records.json
  def index
    
  end

  # GET /records/1
  # GET /records/1.json
  def show
     eval_parsed = {}
     @record.parsed.each do |key, value|
       eval_parsed[key] = eval(value) unless value.to_s.empty?
     end
     respond_to do |format|
       format.html { }
       format.json { @record.parsed = eval_parsed }
     end
  end

  # GET /records/1/thumb
  def thumb
    thumb_url = JSON.parse( @record.parsed[ 'thumbnail' ] )[0]
    thumb_data = open( thumb_url, 'rb' ).read
    send_data thumb_data, type: 'image/png', disposition: 'inline'
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @record }
      else
        format.html { render action: 'new' }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    original = @record.parsed
    amended = params[:record][:parsed]
    @record.update(parsed: amended)
    
    @amendment = @record.amendments.new
    @amendment.user_id = session[:user_id].to_i
    @amendment.previous = original
    @amendment.amended = amended
    @amendment.save
    
    respond_to do |format|
      format.html { redirect_to @record }
      format.json { render json: @amendment }
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:original, :parsed, :belongs_to)
    end
end
