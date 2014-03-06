require 'net/http'
require 'uri'
require 'json'

namespace :curarium do
  desc 'Mass import JSON data based on configuration key'
  task :ingest, [:input_dir, :collection_key, :threads] => [:environment] do |task, args|
    args.with_defaults threads: 4

    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts "Started at #{Time.now}"

    curarium_ingest args[:input_dir], args[:collection_key], args[ :threads ]

    puts "Ended at #{Time.now}"

    ActiveRecord::Base.logger = old_logger
  end

  def curarium_ingest( input_dir, collection_key, threads )
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

    # force 4 threads for now
    ent = Dir.entries input_dir
    puts "Ingesting #{ent.count - 2} records from #{input_dir}"
    puts "Ingesting into collection with key: #{collection_key}"
    puts "Using #{threads} threads"

    j_count = 0
    ent.each_slice( threads ) { |f1, f2, f3, f4| 
      t1 = Thread.new { read_record( input_dir, f1, collection.configuration ) }
      t2 = Thread.new { read_record( input_dir, f2, collection.configuration ) }
      t3 = Thread.new { read_record( input_dir, f3, collection.configuration ) }
      t4 = Thread.new { read_record( input_dir, f4, collection.configuration ) }

      t1.join
      ok = collection.create_record_from_parsed t1[ :original ], t1[ :parsed ] unless t1[ :original ].nil?
      if ok
        j_count += 1
      end

      t2.join
      ok = collection.create_record_from_parsed t2[ :original ], t2[ :parsed ] unless t2[ :original ].nil?
      if ok
        j_count += 1
      end

      t3.join
      ok = collection.create_record_from_parsed t3[ :original ], t3[ :parsed ] unless t3[ :original ].nil?
      if ok
        j_count += 1
      end

      t4.join
      ok = collection.create_record_from_parsed t4[ :original ], t4[ :parsed ] unless t4[ :original ].nil?
      if ok
        j_count += 1
      end

      if j_count > 0 && j_count % 100 < threads
        puts j_count
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count - 2} total files in directory)"
  end

  def read_record( input_dir, f, configuration )
    # thread to wait for file IO, return json
    if f.present? && !File.directory?(f) && File.extname(f) == '.json'
      filename = "./#{input_dir}/#{File.basename(f)}"
      rec_json = IO.read filename

      pr = {}
      configuration.each do |field|
        pr[field[0]] = Collection.follow_json(rec_json, field[1])
      end

      Thread.current[ :original ] = rec_json
      Thread.current[ :parsed ] = pr
    end
  end
end
