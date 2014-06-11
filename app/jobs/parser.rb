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
      
      if Record.exists?(unique_identifier: t[ :unique_identifier ], collection_id: collection_id)
        ok = Record.find_by(unique_identifier: t[ :unique_identifier ], collection_id: collection_id)
        ok.update(parsed: t[:parsed], original: t[:original])
      else
        ok = collection.create_record_from_parsed(t[ :original ], t[ :parsed ], t[ :unique_identifier ])# unless t[ :original ].nil?
      end
      
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
    unique_identifier = ''
    configuration.each do |field|
      unless field[0] == 'unique_identifier'
        pr[field[0]] = Collection.follow_json(json_file, field[1])
      else
        unique_identifier = Collection.follow_json(json_file, field[1])[0]
      end
    end
    
    Thread.current[ :original ] = json_file
    Thread.current[ :parsed ] = pr
    Thread.current[:unique_identifier] = unique_identifier
  end
  
end



  