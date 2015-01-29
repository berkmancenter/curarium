require 'open-uri'
require 'zlib'

class WorksController < ApplicationController
  before_action :set_work, only: [:show, :thumb, :edit, :update, :destroy]

  # GET /works
  # GET /works.json
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
    @num = Work.where( where_clause ).count( :id )

    if params[ :property ].present? && params[ :vis ] == 'treemap'
      if @num == 1
        @work = Work.where( where_clause ).first
        redirect_to @work
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
          FROM "works"
          WHERE #{where_clause}
        ) as subquery
        group by values]

        @works = ActiveRecord::Base.connection.execute(sql)
      end
    elsif  ['thumbnails','list'].include? params[:vis]
      # Array of views that require paging
      @perpage = (params[:per_page].to_i<=0) ? 200 : params[:per_page].to_i
      @page = (params[:page].to_i<=0 || params[:page].to_i > (@num.to_f/@perpage).ceil) ? 1 : params[:page].to_i
      @works = Work.where(where_clause).limit(@perpage).offset((@page-1)*@perpage)
    else
      @works = Work.where(where_clause)
    end
  end

  # GET /works/1
  # GET /works/1.json
  def show
    # for add to tray popout, will have to include cirlce trays later
    @owner = @current_user
    @trays = @owner.all_trays unless @owner.nil?
    @popup_action = 'add'
    @popup_action_type = 'Image'
    @popup_action_item_id = @work.images.first.id

     if @work.amendments.length > 0
       @current_metadata = @work.amendments.last.amended
     else
       @current_metadata = @work.parsed
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
       format.json { @work.parsed = eval_parsed }
       format.js { render action: "show" }
     end
  end

  # GET /works/1/thumb
  def thumb
    # try to get the image from cache
    # if not in cache, send missing_thumb image & attempt to cache again
    if @work.thumbnail_url.nil?
      send_data File.open( "#{Rails.public_path}/missing_thumb.png", 'rb' ).read, type: 'image/png', disposition: 'inline', status: :not_found
    else
      thumb_hash = Zlib.crc32 @work.thumbnail_url

      cache_image = Rails.cache.read "#{thumb_hash}-image"

      if cache_image.nil?
        @work.cache_thumb
      end

      cache_date = Rails.cache.read "#{thumb_hash}-date"
      cache_image = Rails.cache.read "#{thumb_hash}-image"
      cache_type = Rails.cache.read "#{thumb_hash}-type"

      if cache_image.nil?
        send_data File.open( "#{Rails.public_path}/missing_thumb.png", 'rb' ).read, type: 'image/png', disposition: 'inline', status: :not_found
      elsif stale?( etag: thumb_hash, last_modified: cache_date )
        send_data cache_image, type: cache_type, disposition: 'inline'
      end
    end
  end

  # GET /works/new
  def new
    @work = Work.new
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  # POST /works.json
  def create
    @work = Work.new(work_params)

    respond_to do |format|
      if @work.save
        format.html { redirect_to @work, notice: 'Work was successfully created.' }
        format.json { render action: 'show', status: :created, location: @work }
      else
        format.html { render action: 'new' }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    amended = params[:work][:parsed]
    #@work.update(parsed: amended)
    if @work.amendments.length > 0
      last_amendment = @work.amendments.last.amended
    else
      last_amendment = @work.parsed
    end
    
    @amendment = @work.amendments.new
    @amendment.user_id = @current_user.id
    @amendment.previous = last_amendment
    @amendment.amended = amended
    @amendment.save
    
    respond_to do |format|
      format.html { redirect_to @work }
      format.json { render json: @amendment }
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    @work.destroy
    respond_to do |format|
      format.html { redirect_to works_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_params
      params.require(:work).permit(:original, :parsed, :belongs_to)
    end
end
