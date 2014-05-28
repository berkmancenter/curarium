require 'net/http'
require 'uri'
require 'json'

namespace :curarium_remote do
  desc 'Mass import JSON data based on uploaded files'
  task :ingest, [:collection_id] => [:environment] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    curarium_ingest_remote args[:collection_id]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  def curarium_ingest_remote( collection_id )
    usage = "usage: rake curarium:ingest['path/to/input_dir,collection_id']"

    if collection_id.nil?
      puts usage
      return
    end

    if Collection.where( { id: collection_id } ).count == 0
      puts "Cannot find collection with key #{collection_id}"
      return
    end

    collection = Collection.find(collection_id)

    ent = collection.json_files
    puts "Ingesting #{ent.count} records collection: #{collection.name}"

    j_count = 0
    ent.each { |f| 
      configuration = collection.configuration
      read_record_remote( f.path, configuration )
      t = Thread.new { read_record_remote( f.path, configuration ) }

      t.join

      ok = collection.create_record_from_parsed t[ :original ], t[ :parsed ] unless t[ :original ].nil?
      if ok
        j_count += 1
      end

      if j_count > 0 && j_count % 100 == 0
        puts j_count

        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count} total files in directory)"
  end

  def read_record_remote( path, configuration )
    json_file = JSON.parse(Net::HTTP.get(URI(path.to_s)))
    pr = {}
    configuration.each do |field|
      pr[field[0]] = Collection.follow_json(json_file, field[1])
    end

    Thread.current[ :original ] = json_file
    Thread.current[ :parsed ] = pr
  end
end
