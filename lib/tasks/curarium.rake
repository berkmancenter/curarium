require 'net/http'
require 'uri'
require 'json'

namespace :curarium do
  desc 'Mass import JSON data based on configuration key'
  task :ingest, [:input_dir, :collection_key] => [:environment] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    curarium_ingest args[:input_dir], args[:collection_key]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  desc 'Report on status of thumbnail cache'
  task :cache_report => [ :environment ] do 
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    Collection.all.each { |c|
      puts "#{c.name}:"

      not_present = 0
      not_cached = 0
      total = c.works.count

      c.works.each { |r|
        if r.thumbnail_url.present?
          thumb_hash = Zlib.crc32 r.thumbnail_url

          cache_date = Rails.cache.read "#{thumb_hash}-date"
          cache_image = Rails.cache.read "#{thumb_hash}-image"
          cache_type = Rails.cache.read "#{thumb_hash}-type"

          if cache_date.nil? || cache_image.nil? || cache_type.nil?
            not_cached += 1
          end
        else
          not_present += 1
        end
      }

      puts "  total: #{total}"
      puts "  no thumbnail: #{not_present} (#{not_present.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  not cached: #{not_cached} (#{not_cached.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  cached: #{total - not_present - not_cached} (#{( total - not_cached - not_present ).to_f / total.to_f * 100.0 unless total == 0}%)"
    }

    ActiveRecord::Base.logger = old_logger
  end

  desc 'Cache un-cached thumbnails'
  task :cache_thumbs, [:collection_name] => [ :environment ] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    curarium_cache_thumbs args[:collection_name]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  desc 'Pre-render the collection as tiles for object map'
  task :tile_collection, [:collection_id] => [ :environment ] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    tile_collection args[:collection_id]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  def tile_collection( collection_id )
    usage = "usage: rake curarium:tile_collection['collection_id']"

    if collection_id.nil?
      puts usage
      return
    end

    c = Collection.where( { id: collection_id } )

    if c.count == 0
      puts "Cannot find collection with id #{collection_id}"
      return
    end

    c = c.first

    collection_tiles_path = Rails.root.join( 'app', 'assets', 'images', 'collection_tiles', c.id.to_s )
    puts "tiling collection #{c.name} to #{collection_tiles_path}"

    FileUtils.mkpath collection_tiles_path

    rs = c.works.with_thumb
    work_dimension = Math.sqrt( rs.count ).ceil
    zoom_levels = 0

    puts "tiling #{rs.count} works with thumbnails (of #{c.works.count})"

    (0..8).reverse_each { |zoom|
      puts " rd: #{work_dimension}"
      break if work_dimension == 0

      if zoom == 8
        # most zoomed in, each quadkey is one image/thumbnail
        for col in 0..(work_dimension-1)
          for row in 0..(work_dimension-1)
            puts "#{col}, #{row}"

            quadkey = tile_to_quadkey col, row, zoom
            puts "  quadkey: #{quadkey}"

            indexes = quadkey_to_indexes quadkey
            puts "  indexes: #{indexes.join( ',' )}"

            indexes.each { |i|
              if i < rs.count
                r = rs[ i ]
                thumb_hash = Zlib.crc32 r.thumbnail_url
                cache_image = Rails.cache.read "#{thumb_hash}-image"

                File.open( "#{collection_tiles_path}/#{quadkey}.png", 'wb' ) { |f|
                  f.write cache_image
                }
              end
            }
          end
        end
      end

      zoom_levels += 1

      work_dimension /= 2
    }

    puts "total zoom levels: #{zoom_levels}"
  end

  def tile_to_quadkey( column, row, zoom )
    quadkey = ''

    ( 1..zoom ).reverse_each { |i|
      digit = 0
      mask = 1 << (i - 1)

      if ( column & mask ) != 0
        digit += 1
      end

      if ( row & mask ) != 0
        digit += 2
      end

      quadkey += digit.to_s
    }

    quadkey
  end

  def quadkey_to_indexes( quadkey )
    if quadkey.length == 8
      index = 0

      ( 1..(quadkey.length - 1) ).reverse_each { |i|
        digit = quadkey[ i ].to_i
        index += 4 ** (8 - i) * digit / 4
      }

      [ index ]
    else
      [
        quadkey_to_indexes( quadkey + '0' ),
        quadkey_to_indexes( quadkey + '1' ),
        quadkey_to_indexes( quadkey + '2' ),
        quadkey_to_indexes( quadkey + '3' )
      ]
    end
  end

  def curarium_cache_thumbs( collection_name )
    usage = "usage: rake curarium:cache_thumbs['collection_name']"

    if collection_name.nil?
      puts usage
      return
    end

    c = Collection.where( { name: collection_name } )

    if c.count == 0
      puts "Cannot find collection with name #{collection_name}"
      return
    end

    c = c.first

    not_cached = 0
    total = c.works.count

    c.works.with_thumb.each { |r|
      thumb_hash = Zlib.crc32 r.thumbnail_url

      cache_date = Rails.cache.read "#{thumb_hash}-date"
      cache_image = Rails.cache.read "#{thumb_hash}-image"
      cache_type = Rails.cache.read "#{thumb_hash}-type"

      if cache_date.nil? || cache_image.nil? || cache_type.nil?
        r.cache_thumb
        not_cached += 1
      end
    }

    puts "  total: #{total}"
    puts "  attemped to cache: #{not_cached} (#{not_cached.to_f / total.to_f * 100.0 unless total == 0}%)"
  end

  def curarium_ingest( input_dir, collection_key )
    usage = "usage: rake curarium:ingest['path/to/input_dir,collection_key']"

    if input_dir.nil? || collection_key.nil?
      puts usage
      return
    end

    if !Dir.exists? input_dir
      puts "#{input_dir} does not exist"
      return
    end

    if Collection.where( { key: collection_key } ).count == 0
      puts "Cannot find collection with key #{collection_key}"
      return
    end

    ent = Dir.entries input_dir
    puts "Ingesting #{ent.count - 2} works from #{input_dir}"
    puts "Ingesting into collection with key: #{collection_key}"

    collection = Collection.find_by_key( collection_key )
    configuration = collection.configuration

    j_count = 0
    ent.each { |f| 
      next if f.nil? || File.directory?(f) || File.extname(f) != '.json'

      t = Thread.new { read_work( input_dir, f, configuration ) }
      t.join

      unique_identifier = t[ :parsed ][ 'unique_identifier'] unless t[ :parsed ].nil?
      unique_identifier = unique_identifier.to_s unless unique_identifier.nil?

      if unique_identifier.present? && Work.exists?( unique_identifier: unique_identifier, collection_id: collection.id )
        r = Work.find_by( unique_identifier: unique_identifier, collection_id: collection.id )
        r.update( original: t[:original], parsed: t[:parsed] )
        ok = true
      else
        ok = false
        ok = Collection.create_work_from_parsed collection_key, t[ :original ], t[ :parsed ] unless t[ :parsed ].nil?
      end

      if ok
        j_count += 1
      end

      if j_count > 0 && j_count % 100 == 0
        puts j_count

        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count - 2} total files in directory)"
  end

  def read_work( input_dir, f, configuration )
    # thread to wait for file IO, return json
    filename = "./#{input_dir}/#{File.basename(f)}"
    original = JSON.parse IO.read( filename )

    pr = {}

    configuration.each do |field|
      pr[ field[ 0 ] ] = Collection.follow_json original, field[ 1 ]
    end

    Thread.current[ :original ] = original
    Thread.current[ :parsed ] = pr
  end
end
