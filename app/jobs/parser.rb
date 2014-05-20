class Parser
  include SuckerPunch::Job
  require 'zip'
  
  def perform(collection_id, zip_path)
    paths = []
    Zip::File.open(zip_path) do |zip_file|
      zip_file.each do |entry|
        file_path = "#{Rails.root}/tmp/#{entry.name}"
        zip_file.extract(entry, file_path)
        paths << file_path
      end
    end
    paths.shift
    collection = Collection.find(collection_id)
    puts "Ingesting #{paths.count} records collection: #{collection.name}"
    configuration = collection.configuration


    j_count = 0
    paths.each { |path| 
      read_record( path, configuration )
      t = Thread.new { read_record( path, configuration ) }

      t.join

      ok = collection.create_record_from_parsed t[ :original ], t[ :parsed ] unless t[ :original ].nil?
      if ok
        j_count += 1
      end
      
      if j_count > 0 && j_count % 100 == 0
        puts j_count
        File.delete(path)
        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
      end
    }
    File.delete(zip_path)
    collection.approved = true
    collection.save
    puts "Processed #{j_count} JSON files (out of #{paths.count} total files in directory)" 
  end
  
  def read_record( path, configuration )
    json_file = JSON.parse(File.open(path, 'r').read)
    pr = {}
    configuration.each do |field|
      pr[field[0]] = Collection.follow_json(json_file, field[1])
    end

    Thread.current[ :original ] = json_file
    Thread.current[ :parsed ] = pr
  end
  
end



  