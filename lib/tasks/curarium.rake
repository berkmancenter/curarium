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
      total = c.records.count

      c.records.each { |r|
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
    total = c.records.count

    c.records.each { |r|
      next if r.thumbnail_url.nil?

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
    puts "Ingesting #{ent.count - 2} records from #{input_dir}"
    puts "Ingesting into collection with key: #{collection_key}"

    collection = Collection.find_by_key( collection_key )
    configuration = collection.configuration

    j_count = 0
    ent.each { |f| 
      next if f.nil? || File.directory?(f) || File.extname(f) != '.json'

      t = Thread.new { read_record( input_dir, f, configuration ) }
      t.join

      unique_identifier = t[ :parsed ][ 'unique_identifier'] unless t[ :parsed ].nil?
      unique_identifier = unique_identifier.to_s unless unique_identifier.nil?

      if unique_identifier.present? && Record.exists?( unique_identifier: unique_identifier, collection_id: collection.id )
        r = Record.find_by( unique_identifier: unique_identifier, collection_id: collection.id )
        r.update( original: t[:original], parsed: t[:parsed] )
        ok = true
      else
        ok = false
        ok = Collection.create_record_from_parsed collection_key, t[ :original ], t[ :parsed ] unless t[ :parsed ].nil?
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

  def read_record( input_dir, f, configuration )
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
