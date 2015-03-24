class ImportWork
  include Sidekiq::Worker

  def perform( collection_id, configuration, json_file_path )
    original = JSON.parse IO.read( json_file_path )
    parsed = {}

    configuration.each { |field|
      parsed[ field[ 0 ] ] = Collection.follow_json original, field[ 1 ]
    }

    unique_identifier = parsed[ 'unique_identifier' ]
    unique_identifier = unique_identifier.to_s unless unique_identifier.nil?

    if unique_identifier.present? && Work.exists?( unique_identifier: unique_identifier, collection_id: collection_id )
      w = Work.find_by unique_identifier: unique_identifier, collection_id: collection_id
      w.update original: original, parsed: parsed
    else
      w = Work.create collection_id: collection_id, original: original, parsed: parsed
    end

    w.cache_thumb

    sleep 0.5
  end
end

