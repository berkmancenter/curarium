class Parser
  include SuckerPunch::Job
  #LogJob.new.async.perform

  def perform(collection_id)
    collection = Collection.find(collection_id)
    puts collection.name
    ent = collection.json_files
    puts "Ingesting #{ent.count} records collection: #{collection.name}"
    configuration = collection.configuration


    j_count = 0
    ent.each { |f| 
      read_record( f.path, configuration )
      t = Thread.new { read_record( f.path, configuration ) }

      t.join

      ok = collection.create_record_from_parsed t[ :original ], t[ :parsed ] unless t[ :original ].nil?
      if ok
        j_count += 1
        f.destroy
      end
      
      if j_count > 0 && j_count % 100 == 0
        puts j_count

        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count} total files in directory)" 
  end
  
  def read_record( path, configuration )
    json_file = JSON.parse(Net::HTTP.get(URI(path.to_s)))
    pr = {}
    configuration.each do |field|
      pr[field[0]] = Collection.follow_json(json_file, field[1])
    end

    Thread.current[ :original ] = json_file
    Thread.current[ :parsed ] = pr
  end
  
end



  