require 'open-uri'
require 'zlib'

class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :thumb, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:show,:thumb, :index]

  # GET /records
  # GET /records.json
  def index
    where_clause = ''

    if params[ :collection_id ].present?
      where_clause << ActiveRecord::Base.send( :sanitize_sql_array, [ ' collection_id = %s', params[:collection_id] ] )
      @collection = Collection.find(params[:collection_id])
      @properties = @collection.configuration.keys
    else 
      coll = Collection.all
      @properties = []
      coll.each do |c|
        c.configuration.keys.each do |p|
          @properties << p unless @properties.include? p
        end
      end
    end

    @properties -= ['thumbnail','image','unique_identifier']

    if params[:include].present?
      # break out values to avoid SQL injection
      where_values = ['']

      params[:include].each_with_index { |p, i|
        values = p.split ':'

        if i > 0
          where_values[0] = where_values[0] + ' AND '
        end

        where_values[0] = where_values[0] + "lower(parsed->'#{values[0]}') like '%s'"
        where_values << "%#{values[1].downcase}%"
      }

      where_clause << " AND ( #{ActiveRecord::Base.send( :sanitize_sql_array, where_values )} )"
    end

    if params[:exclude].present?
      # break out values to avoid SQL injection
      where_values = ['']

      params[:exclude].each_with_index { |p, i|
        values = p.split ':'

        if i > 0
          where_values[0] = where_values[0] + ' OR '
        end

        where_values[0] = where_values[0] + "lower(parsed->'#{values[0]}') like '%s'"
        where_values << "%#{values[1].downcase}%"
      }

      where_clause << " AND NOT ( #{ActiveRecord::Base.send( :sanitize_sql_array, where_values )} )"
    end

    # may want num in a few cases (this should be a fast query)
    @num = Record.where( where_clause ).count( :id )

    if params[ :property ].present? && params[ :vis ] == 'treemap'
      if @num == 1
        @record = Record.where( where_clause ).first
        redirect_to @record
      else
        property = ActiveRecord::Base.send( :sanitize_sql_array, [ '%s', params[ :property ] ] )

        # ["a", "b, b", "c"]
        # ["a%SPLIT%b, b%SPLIT%c"]
        # a%SPLIT%b, b%SPLIT%c
        # a -- b, b -- c
        sql = %[select values as parsed, count(values) as id from (
          SELECT  trim(
            both from unnest(
              string_to_array(
                regexp_replace(
                  regexp_replace(
                    lower(parsed->'#{property}'), '", "', '%SPLIT%', 'g'
                  ), '[\\[\\]"]', '', 'g'
                ), '%SPLIT%'
              )
            )
          ) as values
          FROM "records"
          WHERE #{where_clause}
        ) as subquery
        group by values]

        @records = ActiveRecord::Base.connection.execute(sql)
      end
    elsif  ['thumbnails','list'].include? params[:vis]
      # Array of views that require paging
      @perpage = (params[:per_page].to_i<=0) ? 200 : params[:per_page].to_i
      @page = (params[:page].to_i<=0 || params[:page].to_i > (@num.to_f/@perpage).ceil) ? 1 : params[:page].to_i
      @records = Record.where(where_clause).limit(@perpage).offset((@page-1)*@perpage)
    else
      @records = Record.where(where_clause)
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
     if @record.amendments.length > 0
       @current_metadata = @record.amendments.last.amended
     else
       @current_metadata = @record.parsed
     end
     eval_parsed = {}
     @current_metadata.each do |key, value|
       eval_parsed[key] = JSON.parse(value) unless value.to_s.empty?
     end
     respond_to do |format|
       format.html {
         if request.xhr?
           render 'show_xhr', layout: false
         else
           render
         end
       }
       format.json { @record.parsed = eval_parsed }
       format.js { render action: "show" }
     end
  end

  def image_type( local_file_path )
    png = Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))

    case IO.read(local_file_path, 10)
    when /^GIF8/
      'gif'
    when /^#{png}/
      'png'
    when /^#{jpg}/
      'jpeg'
    else
      '*'
    end
  end
    
  # GET /records/1/thumb
  def thumb
    # try to get the image from cache
    # if not in cache, send missing_thumb image & attempt to cache again
    if @record.thumbnail_url.nil?
      send_data File.open( "#{Rails.public_path}/missing_thumb.png", 'rb' ).read, type: 'image/png', disposition: 'inline', status: :not_found
    else
      thumb_hash = Zlib.crc32 @record.thumbnail_url

      cache_date = Rails.cache.read "#{thumb_hash}-date"
      cache_image = Rails.cache.read "#{thumb_hash}-image"
      cache_type = Rails.cache.read "#{thumb_hash}-type"

      if ( cache_date.nil? || cache_image.nil? || cache_type.nil? )
        send_data File.open( "#{Rails.public_path}/missing_thumb.png", 'rb' ).read, type: 'image/png', disposition: 'inline', status: :accepted
        @record.cache_thumb
      else
        if stale?( etag: thumb_hash, last_modified: cache_date )
          send_data cache_image, type: cache_type, disposition: 'inline'
        end
      end
    end
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
    amended = params[:record][:parsed]
    #@record.update(parsed: amended)
    if @record.amendments.length > 0
      last_amendment = @record.amendments.last.amended
    else
      last_amendment = @record.parsed
    end
    
    @amendment = @record.amendments.new
    @amendment.user_id = session[:user_id].to_i
    @amendment.previous = last_amendment
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
