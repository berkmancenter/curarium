require 'net/http'
require 'uri'
require 'json'

namespace :curarium do
  desc 'Mass import JSON data based on configuration key'
  task :ingest, [:input_dir, :collection_key] => [:environment] do |task, args|
    curarium_ingest args[:input_dir], args[:collection_key]
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
      rec_json = IO.read f



      j_count += 1

#
#          # send the record's json to server
#          response = Net::HTTP.post_form(URI.parse(base + "/collections/" + key + "/ingest"), {"j" => rec_json})
#          if !response.body.empty?
#            j_count = j_count + 1
#            puts "success!"
#          end
#        rescue
#          puts "something went wrong"
#        end
    }

    puts "Processed #{j_count} JSON files (out of #{ent.count - 2} total files in directory)"
  end
end
