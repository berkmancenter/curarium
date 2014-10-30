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
    puts "Ingesting #{paths.count} works collection: #{collection.name}"
    configuration = collection.configuration


    j_count = 0
    paths.each { |f| 
      next if f.nil? || File.directory?(f) || File.extname(f) != '.json'

      t = Thread.new { read_work( f, configuration ) }
      t.join
      
      unique_identifier = t[ :parsed ][ 'unique_identifier'] unless t[ :parsed ].nil?
      unique_identifier = unique_identifier.to_s unless unique_identifier.nil?

      if unique_identifier.present? && Work.exists?( unique_identifier: unique_identifier, collection_id: collection.id )
        r = Work.find_by( unique_identifier: unique_identifier, collection_id: collection.id )
        r.update( original: t[:original], parsed: t[:parsed] )
        ok = true
      else
        ok = false
        ok = collection.create_work_from_parsed t[ :original ], t[ :parsed ] unless t[ :parsed ].nil?
      end
      
      if ok
        j_count += 1
      end
      
      if j_count > 0 && j_count % 100 == 0
        puts j_count
        #File.delete(path)

        GC.start
        puts "heap: #{GC.stat[ :heap_live_num ]}"
      end
    }
    #File.delete(zip_path)
    collection.approved = true
    collection.save
    puts "Processed #{j_count} JSON files (out of #{paths.count - 2} total files in directory)" 
  end
  
  def read_work( f, configuration )
    original = JSON.parse(File.open(f, 'r').read)

    pr = {}

    configuration.each do |field|
      pr[ field[ 0 ] ] = Collection.follow_json original, field[ 1 ]
    end
    
    Thread.current[ :original ] = original
    Thread.current[ :parsed ] = pr
  end
  
end



  
