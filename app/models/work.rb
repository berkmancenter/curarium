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
    if thumbnail_url.present?
      cache_url = "#{thumbnail_url}#{thumbnail_url.include?( '?' ) ? '&' : '?'}width=256&height=256"

      begin
        thumb_connection = open cache_url, 'rb', 'User-Agent' => Curarium::BOT_UA
      rescue Net, OpenURI::HTTPError => e
        thumb_connection = nil
      end

      if thumb_connection.present?
        File.open( thumbnail_cache_path, 'wb' ) { |file|
          file.write thumb_connection.read
        }
      end
    end

  end

  def annotations
    # shortcut to first image's annotations
    images.first.annotations
  end

  private

  def extract_attributes
    if id.nil?
      self.unique_identifier = parsed[ 'unique_identifier' ].to_s unless parsed[ 'unique_identifier' ].nil?

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

      # maybe can be nil?
      titles = parsed[ 'title' ]
      self.title = titles.is_a?( Array ) ? titles[ 0 ] : titles

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
