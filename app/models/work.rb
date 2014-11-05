require 'open-uri'
require 'zlib'

class Work < ActiveRecord::Base
  belongs_to :collection

  has_many :annotations, dependent: :destroy
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
    
  def cache_thumb
    if images.any?
      thumbnail_url = images.first.thumbnail_url
      if thumbnail_url.present?
        thumb_hash = Zlib.crc32 thumbnail_url
        cache_url = "#{thumbnail_url}#{thumbnail_url.include?( '?' ) ? '&' : '?'}width=256&height=256"
        #puts cache_url

        begin
          thumb_connection = open cache_url, 'rb'
        rescue Net, OpenURI::HTTPError => e
          thumb_connection = nil
        end

        if thumb_connection.nil?
          # sleep & try one more time
          sleep 0.5

          begin
            thumb_connection = open cache_url, 'rb'
          rescue Net, OpenURI::HTTPError => e
            thumb_connection = nil
          end
        end

        if thumb_connection.present?
          Rails.cache.write "#{thumb_hash}-date", Date.today
          Rails.cache.write "#{thumb_hash}-image", thumb_connection.read

          if thumb_connection.is_a? Tempfile
            Rails.cache.write "#{thumb_hash}-type", "image/#{Work.image_type thumb_connection.path}"
          else
            Rails.cache.write "#{thumb_hash}-type", thumb_connection.meta[ 'content-type' ]
          end
        end
      end
    end
  end

  private

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
      thumbnail_url = turls[ i ] unless turls.nil?
      self.images.create( image_url: image_url, thumbnail_url: thumbnail_url )
    } unless iurls.nil?
  end

  attr_accessor :iurls
  attr_accessor :turls
end
