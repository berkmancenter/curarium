require 'net/http'
require 'uri'
require 'json'

namespace :curarium do
  desc 'Mass import JSON data based on configuration key'
  task :ingest, [:input_dir, :collection_key] => [:environment] do |task, args|
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    curarium_ingest args[:input_dir], args[:collection_key]

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
    ent.each { |f| 
      next if File.directory?(f) || File.extname(f) != '.json'

      # extract json of this file's record
      filename = "./#{input_dir}/#{File.basename(f)}"
      rec_json = IO.read filename
      

      configuration = collection.configuration
      properties = collection.properties.to_json
      properties = JSON.parse(properties)

      r = collection.records.new
      r.original = rec_json
      r.save

      pr = {}
      pr['curarium'] = [r.id]

      configuration.each do |field|
        pr[field[0]] = collection.follow_json(r.original, field[1])
        if pr[field[0]] == nil or ['thumbnail','image'].include?(field[0])
          next
        end
        pr[field[0]].each do |p|
          if(properties[field[0]][p] == nil)
            properties[field[0]][p] = 1
          else
            properties[field[0]][p] = properties[field[0]][p] + 1
           end
         end
      end

      collection.update(properties: properties)
      r.parsed = pr

      if r.save
        j_count += 1

        if j_count % 100 == 0
          puts j_count
        end
      end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count - 2} total files in directory)"
  end
end
