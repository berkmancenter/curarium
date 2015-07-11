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

  def self.write_montage( works, path, force = false, ids_only = false )
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

      if !ids_only
        File.open( path.join( 'thumbnails.txt' ), 'w' ) { |f|
          public_works_path = '../../works/'
          f.write( ws.map { |w| public_works_path + "#{w.id}.jpg" }.join( "\n" ) )
        }

        Dir.chdir( path ) {
          %x[montage @thumbnails.txt -tile #{work_dimension}x#{work_dimension} -geometry 16x16 -gravity NorthWest #{path.join( '5.jpg' )}]
        }
      end
    end
  end

  def self.write_geochrono( works, path, force = false, ids_only = false )
    logger.info "geochrono works to #{path}"

    if File.exists?( path.join( '5.jpg' ) ) && !force
      logger.info "geochrono already exists"
    else
      FileUtils.mkpath path

      ws = works.with_thumb
      work_dimension = Math.sqrt( ws.count ).ceil

      File.open( path.join( 'ids.json' ), 'w' ) { |f|
        f.write( ws.pluck( :id, :datestart, :dateend ).to_json )
      }

      if !ids_only
        File.open( path.join( 'thumbnails.txt' ), 'w' ) { |f|
          public_works_path = '../../works/'
          f.write( ws.map { |w| public_works_path + "#{w.id}.jpg" }.join( "\n" ) )
        }

        Dir.chdir( path ) {
          %x[geochrono @thumbnails.txt -tile #{work_dimension}x#{work_dimension} -geometry 16x16 -gravity NorthWest #{path.join( '5.jpg' )}]
        }
      end
    end
  end

  def self.missing_thumb_url
    Rails.public_path.join( 'missing_thumb.png' ).to_s
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
      missing_thumb_url
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
      %x[convert #{thumbnail_cache_path} -segment 1x0.125 #{thumbnail_cache_path}.cvt.png]
      %x[convert #{thumbnail_cache_path} -segment 1x0.125 -format "%c" histogram:info:#{thumbnail_histogram_path}]
      
      File.open( thumbnail_histogram_path, 'r' ) { |f|
        total_colors = 0.0
        lines = 0
        f.each_line { |line|
          parts = line.scan /^\s*(\d+):.*(#\w*)/
          next if parts.empty?
          count = parts[0][0].to_f
          color = parts[0][1]
          histogram << { color: color, count: count }
          total_colors += count
          lines += 1
        }
        lines = 5 if lines > 5
        histogram = histogram.sort_by { |h| h[ :count ] }.slice( -lines, lines ).reverse.map { |h|
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
      uids = parsed[ 'unique_identifier' ]
      if uids.present?
        if uids.is_a? String
          if uids[0] == '['
            self.unique_identifier = JSON.parse( uids )[ 0 ]
          else
            self.unique_identifier = uids
          end
        elsif uids.is_a? Array
          self.unique_identifier = uids[ 0 ]
        end
      end

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
      titles = parsed[ 'title' ]
      if titles.present?
        if titles.is_a? String
          if titles[0] == '['
            self.title = JSON.parse( titles )[ 0 ]
          else
            self.title = titles
          end
        elsif titles.is_a? Array
          self.title = titles[ 0 ]
        end
      end

      # can be nil
      self.datestart = Work.parse_date parsed[ 'datestart' ]

      # can be nil
      self.dateend = Work.parse_date parsed[ 'dateend' ]

      # remove the attributes we extracted (except for title)
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
