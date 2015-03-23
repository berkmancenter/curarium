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
      'gif'
    when /^#{png}/
      'png'
    when /^#{jpg}/
      'jpeg'
    else
      '*'
    end
  end
    
  def thumbnail_url
    if images.any?
      images.first.thumbnail_url
    end
  end

  def cache_thumb
    if thumbnail_url.present?
      thumb_hash = Zlib.crc32 thumbnail_url
      cache_url = "#{thumbnail_url}#{thumbnail_url.include?( '?' ) ? '&' : '?'}width=256&height=256"

      begin
        uri = URI cache_url

        req = create_request uri

        http = Net::HTTP.new uri.hostname, uri.port

        http.open_timeout = 10
        http.read_timeout = 20

        res = http.start{ |http| http.request req }

        #proxy_content = res.body.encode

        Rails.cache.write "#{thumb_hash}-date", Date.today
        Rails.cache.write "#{thumb_hash}-image", res.body
        Rails.cache.write "#{thumb_hash}-type", "image/jpeg" #{Work.image_type thumb_connection.path}"
      rescue Net, OpenURI::HTTPError => e
        logger.info 'error'
      end
    end
  end

  def annotations
    # shortcut to first image's annotations
    images.first.annotations
  end

  private
  
  def create_request( uri )
    req = Net::HTTP::Get.new uri
    req['Accept'] = 'image/*;q=0.8'
    req['Accept-Language'] = 'en-US,en;q=0.8'
    req['Connection'] = 'close'
    req['User-Agent'] = 'CurariumBot/0.4.8 (+http://curarium.com/bot)'
    req
  end

  def extract_attributes
    if id.nil?
      self.unique_identifier = parsed[ 'unique_identifier' ].to_s unless parsed[ 'unique_identifier' ].nil?

      # can be nil
      self.iurls = parsed[ 'image' ]
      self.turls = parsed[ 'thumbnail' ]

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
