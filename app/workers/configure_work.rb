class ConfigureWork
  include Sidekiq::Worker
  sidekiq_options :retry => 3, :dead => false
  
  def perform( collection_id, configuration, work_id )
    begin
      work = Work.find work_id
      parsed = {}

      Rails.logger.debug "[reconfigure] work: #{work_id}, configuration: #{configuration}"

      configuration.each { |field|
        Rails.logger.debug "[reconfigure] #{field.inspect}"
        parsed[ field[ 0 ] ] = Collection.follow_json work.original, field[ 1 ]
      }

      Rails.logger.debug "[reconfigure] work #{work_id}, parsed: #{parsed.inspect}"

      work.update parsed: parsed

      if work.cache_thumb
        histogram = work.extract_colors
        if histogram.any?
          work.update primary_color: histogram[0][ :color ], top_colors: histogram
        end
      end

      sleep 1
    rescue Exception => e
      Rails.logger.info "[reconfigure] work: #{work_id}, error: #{e.inspect}"
    end
  end
end

