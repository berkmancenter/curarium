require 'open-uri'
require 'zlib'

class Record < ActiveRecord::Base
  has_many :annotations, dependent: :destroy
  has_many :amendments, dependent: :destroy
  belongs_to :collection

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
    thumb_url = JSON.parse( parsed[ 'thumbnail' ] )[0]

    if thumb_url.present?
      thumb_hash = Zlib.crc32 thumb_url
      cache_url = "#{thumb_url}#{thumb_url.include?( '?' ) ? '&' : '?'}width=256&height=256"
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
          Rails.cache.write "#{thumb_hash}-type", "image/#{Record.image_type thumb_connection.path}"
        else
          Rails.cache.write "#{thumb_hash}-type", thumb_connection.meta[ 'content-type' ]
        end
      end
    end
  end
end
