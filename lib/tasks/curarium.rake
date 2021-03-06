require 'net/http'
require 'uri'
require 'json'

namespace :curarium do
  desc 'Mass import JSON data based on configuration key'
  task :ingest, [:input_dir, :collection_key] => [:environment] do |task, args|
    puts 'DEPRECATED: Please use the website to import collections'

    #old_logger = ActiveRecord::Base.logger
    #ActiveRecord::Base.logger = nil

    #puts "Started at #{Time.now}"

    #curarium_ingest args[:input_dir], args[:collection_key]

    #puts "Ended at #{Time.now}"

    #ActiveRecord::Base.logger = old_logger
  end

  desc 'Report on status of thumbnail cache'
  task :cache_report => [ :environment ] do 
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    Collection.all.each { |c|
      puts "#{c.name} (#{c.id}):"

      total = c.works.count

      works = c.works.with_thumb

      no_thumb = total - works.count
      not_cached = 0

      works.each { |w|
        if !File.exist?( w.thumbnail_cache_path )
          not_cached += 1
        end
      }

      puts "  total: #{total}"
      puts "  no thumbnail: #{no_thumb } (#{no_thumb.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  not cached: #{not_cached} (#{not_cached.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  cached: #{total - no_thumb - not_cached} (#{( total - not_cached - no_thumb ).to_f / total.to_f * 100.0 unless total == 0}%)"
    }

    ActiveRecord::Base.logger = old_logger
  end

  desc 'Export thumbnails from Rails.cache to /public'
  task :export_cache => [ :environment ] do 
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    collection_thumbs_path = Rails.public_path.join( 'thumbnails', 'works' )

    FileUtils.mkpath collection_thumbs_path

    Collection.all.each { |c|
      puts "#{c.name} (#{c.id}):"

      total = c.works.count

      works = c.works.with_thumb

      no_thumb = total - works.count
      not_cached = 0
      exported = 0

      works.each { |w|
        cache_image = Rails.cache.read "#{w.thumb_hash}-image"

        if cache_image.present?
          File.open( collection_thumbs_path.join( "#{w.id}.jpg" ).to_s, 'wb' ) { |file|
            file.write cache_image
          }

          exported += 1
        else
          not_cached += 1
        end
      }

      puts "  total: #{total}"
      puts "  no thumbnail: #{no_thumb } (#{no_thumb.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  not_cached: #{not_cached} (#{not_cached.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  exported: #{exported} (#{exported.to_f / total.to_f * 100.0 unless total == 0}%)"
      puts "  cached: #{total - no_thumb - not_cached - exported} (#{( total - not_cached - no_thumb - exported ).to_f / total.to_f * 100.0 unless total == 0}%)"
    }

    ActiveRecord::Base.logger = old_logger
  end

  desc 'Cache un-cached thumbnails'
  task :cache_thumbs, [:collection_id] => [ :environment ] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    curarium_cache_thumbs args[:collection_id]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  desc 'Pre-render the collection as tiles for object map'
  task :tile_collection, [:collection_id] => [ :environment ] do |task, args|
    puts "Started at #{Time.now}"

    tile_collection args[:collection_id]

    puts "Ended at #{Time.now}"
  end

  def tile_collection( collection_id )
    usage = "usage: rake curarium:tile_collection['collection_id']"

    if collection_id.nil?
      puts usage
      return
    end

    if !Collection.exists?( collection_id )
      puts "Cannot find collection with id #{collection_id}"
      return
    end

    c = Collection.find collection_id

    collection_tiles_path = Rails.public_path.join( 'thumbnails', 'collections', c.id.to_s )

    Work.write_montage( c.works.with_thumb, collection_tiles_path )
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

  def curarium_cache_thumbs( collection_id )
    usage = "usage: rake curarium:cache_thumbs['collection_id']"

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

    not_cached = 0
    total = c.works.count

    puts "  total: #{total}"

    j_count = 0

    c.works.with_thumb.each { |w|
      if !File.exists?( w.thumbnail_cache_path )
        w.cache_thumb
        sleep 0.5

        not_cached += 1

        j_count += 1

        if j_count > 0 && j_count % 100 == 0
          puts j_count
        end
      end
    }

    puts "  attemped to cache: #{not_cached} (#{not_cached.to_f / total.to_f * 100.0 unless total == 0}%)"
  end

  def curarium_ingest( input_dir, collection_key )
    usage = "usage: rake curarium:ingest['path/to/input_dir,collection_key_or_id']"

    if input_dir.nil? || collection_key.nil?
      puts usage
      return
    end

    if !Dir.exists? input_dir
      puts "#{input_dir} does not exist"
      return
    end

    if collection_key.length < 20
      c = Collection.where id: collection_key.to_i
      if c.any?
        collection_key = c.first.key
      else
        puts "Cannot find collection with id #{collection_key}"
        return
      end
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
        w = Work.find_by( unique_identifier: unique_identifier, collection_id: collection.id )
        w.update( original: t[:original], parsed: t[:parsed] )
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
