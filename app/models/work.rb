require 'open-uri'
require 'net/http'
require 'zlib'

class Work < ActiveRecord::Base
  belongs_to :collection

  has_many :amendments, dependent: :destroy
  has_many :images, dependent: :destroy

  before_save :extract_attributes
  after_save :create_images

  scope :with_thumb, -> {
    where( 'works.id in ( select distinct works.id from works inner join images on images.work_id = works.id where not images.thumbnail_url is null )' )
  }

  scope :approved, -> {
    where "collection_id in ( select id from collections where approved = true )"
  }

  def self.parse_float( values )
    fl = nil

    if values.present?
      if values.is_a? String
        if values[0] == '['
          fl = JSON.parse( values )[ 0 ]
        else
          fl = values
        end
      elsif values.is_a? Array
        fl = values[ 0 ]
      end
    end

    if fl.present?
      fl.to_f
    else
      fl
    end
  end

  def self.parse_string( values )
    str = nil

    if values.present?
      if values.is_a? String
        if values[0] == '['
          str = JSON.parse( values )[ 0 ]
        else
          str = values
        end
      elsif values.is_a? Array
        str = values[ 0 ]
      end
    end

    str
  end

  def self.parse_date( dates )
    # grab the first true string and try to parse as a date
    date_string = nil

    if dates.present?
      if dates.is_a? String
        if dates[0] == '['
          date_string = JSON.parse( dates )[ 0 ]
        else
          date_string = dates
        end
      elsif dates.is_a? Array
        date_string = dates[ 0 ]
      end
    end

    if date_string.present?
      date_string = date_string.to_s
      begin
        if date_string != '0'
          if date_string.length <= 4
            # assume only year
            Date.parse "#{date_string}-01-01"
          else
            Date.parse date_string
          end
        end
      rescue ArgumentError => e
        # not a date
      end
    end
  end

  def self.image_type( local_file_path )
    png = Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))

    case IO.read(local_file_path, 10)
    when /^GIF8/
      'image/gif'
    when /^#{png}/
      'image/png'
    when /^#{jpg}/
      'image/jpeg'
    else
      'image/*'
    end
  end

  def self.write_montage( works, path, force = false )
    logger.info "montage works to #{path}"

    if File.exists?( path.join( '5.jpg' ) ) && !force
      logger.info "montage already exists"
    else
      FileUtils.mkpath path

      ws = works.with_thumb
      work_dimension = Math.sqrt( ws.count ).ceil

      File.open( path.join( 'ids.json' ), 'w' ) { |f|
        f.write( ws.pluck( :id ).to_json )
      }

      File.open( path.join( 'thumbnails.txt' ), 'w' ) { |f|
        public_works_path = '../../works/'
        f.write( ws.map { |w| public_works_path + "#{w.id}.jpg" }.join( "\n" ) )
      }

      Dir.chdir( path ) {
        %x[montage @thumbnails.txt -tile #{work_dimension}x#{work_dimension} -geometry 16x16 -gravity NorthWest #{path.join( '5.jpg' )}]
      }
    end
  end
    
  def thumbnail_url
    if images.any?
      images.first.thumbnail_url
    end
  end

  def thumb_hash
    Zlib.crc32 thumbnail_url
  end

  def thumbnail_cache_path
    Rails.public_path.join( 'thumbnails', 'works', "#{id}.jpg" ).to_s
  end

  def thumbnail_histogram_path
    Rails.public_path.join( 'thumbnails', 'works', "#{id}.txt" ).to_s
  end

  def thumbnail_cache_type
    'image/jpeg'
    #Work.image_type thumbnail_cache_path
  end

  def thumbnail_cache_url
    if thumbnail_url.present?
      "/thumbnails/works/#{id}.jpg"
    else
      '/missing_thumb.png'
    end
  end

  def cache_thumb
    result = File.exists? thumbnail_cache_path
    if !result && thumbnail_url.present?
      cache_url = "#{thumbnail_url}#{thumbnail_url.include?( '?' ) ? '&' : '?'}width=150&height=150"

      begin
        thumb_connection = open cache_url, 'rb', 'User-Agent' => Curarium::BOT_UA
      rescue Net, OpenURI::HTTPError => e
        thumb_connection = nil
      end

      if thumb_connection.present?
        File.open( thumbnail_cache_path, 'wb' ) { |file|
          file.write thumb_connection.read
          result = true
        }
      end
    end
    result
  end

  def extract_colors
    histogram = [] 
    if File.exists?( thumbnail_cache_path )
      # pixelate via scale, convert to 8bit, then extract histogram
      #%x[convert #{thumbnail_cache_path} -scale 20% -colors 256 -depth 8 #{thumbnail_cache_path}.8bit.png]
      %x[convert #{thumbnail_cache_path} -scale 20% -colors 256 -depth 8 -format "%c" histogram:info:#{thumbnail_histogram_path}]
      File.open( thumbnail_histogram_path, 'r' ) { |f|
        total_colors = 0.0
        f.each_line { |line|
          parts = line.scan /^\s*(\d+):.*(#\w*)/
          next if parts.empty?
          count = parts[0][0].to_f
          color = parts[0][1]
          histogram << { color: color, count: count }
          total_colors += count
        }
        histogram = histogram.sort_by { |h| h[ :count ] }.slice( -5, 5 ).reverse.map { |h|
          {
            color: h[ :color ],
            percent: h[ :count ] / total_colors
          }
        }
      }
      histogram
    end
  end

  def annotations
    # shortcut to first image's annotations
    images.first.annotations
  end

  private

  def extract_attributes
    if id.nil?
      # maybe can be nil?
      self.unique_identifier = Work.parse_string parsed[ 'unique_identifier' ]

      # can be nil
      if parsed[ 'image' ].present?
        if parsed[ 'image' ].is_a? String
          self.iurls = JSON.parse parsed[ 'image' ]
        else
          self.iurls = parsed[ 'image' ]
        end
      end

      # can be nil
      if parsed[ 'thumbnail' ].present?
        if parsed[ 'thumbnail' ].is_a? String
          self.turls = JSON.parse parsed[ 'thumbnail' ]
        else
          self.turls = parsed[ 'thumbnail' ]
        end
      end

      # can be nil, maybe?
      self.title = Work.parse_string parsed[ 'title' ]

      # can be nil
      self.datestart = Work.parse_date parsed[ 'datestart' ]

      # can be nil
      self.dateend = Work.parse_date parsed[ 'dateend' ]

      lat = Work.parse_float parsed[ 'latitude' ]
      lon = Work.parse_float parsed[ 'longitude' ]

      if lat.present? && lon.present?
        self.location = "POINT(#{lon} #{lat})"
      end

      # remove some attributes from metadata
      self.parsed.except! 'unique_identifier', 'image', 'thumbnail'
    end
  end

  def create_images
    iurls.each_with_index { |image_url, i|
      turl = turls[ i ] unless turls.nil?
      self.images.create( image_url: image_url, thumbnail_url: turl )
    } unless iurls.nil?
  end

  attr_accessor :iurls
  attr_accessor :turls
end
