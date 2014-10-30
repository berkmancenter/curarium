require 'open-uri'
require 'zlib'

class Work < ActiveRecord::Base
  has_many :annotations, dependent: :destroy
  has_many :amendments, dependent: :destroy
  belongs_to :collection

  before_save :extract_attributes

  scope :with_thumb, -> {
    where( 'not thumbnail_url is null' )
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

  private

  def extract_attributes
    self.unique_identifier = parsed[ 'unique_identifier' ].to_s unless parsed[ 'unique_identifier' ].nil?

    # can be nil
    thumbnails = parsed[ 'thumbnail' ]
    self.thumbnail_url = thumbnails.is_a?( Array ) ? thumbnails[ 0 ] : thumbnails

    # maybe can be nil?
    titles = parsed[ 'title' ]
    self.title = titles.is_a?( Array ) ? titles[ 0 ] : titles

    # remove the attributes we extracted (except for title)
    self.parsed.except! 'unique_identifier', 'thumbnail'
  end
end
