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

    collection = Collection.find_by_key collection_key

    if collection.nil?
      puts "Cannot find collection with key #{collection_key}"
      return
    end

    ent = Dir.entries input_dir
    puts "Ingesting #{ent.count - 2} records from #{input_dir}"
    puts "Ingesting into collection with key: #{collection_key}"

    j_count = 0
    ent.each_slice( 2 ) { |f1, f2| 
      t1 = Thread.new { read_record( input_dir, f1 ) }
      t2 = Thread.new { read_record( input_dir, f2 ) }

      t1.join
      ok = collection.create_record_from_json t1[ :json ] unless t1[ :json ].nil?
      if ok
        j_count += 1
      end

      t2.join
      ok = collection.create_record_from_json t2[ :json ] unless t2[ :json ].nil?
      if ok
        j_count += 1
      end


      if j_count % 100 == 0
        puts j_count
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count - 2} total files in directory)"
  end

  def read_record( input_dir, f )
    # thread to wait for file IO, return json
    if !File.directory?(f) && File.extname(f) == '.json'
      filename = "./#{input_dir}/#{File.basename(f)}"
      Thread.current[ :json ] = IO.read filename
    end
  end
end
