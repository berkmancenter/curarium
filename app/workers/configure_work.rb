class ConfigureWork
  include Sidekiq::Worker
  sidekiq_options :retry => 3, :dead => false
  

  def perform( configuration, work_id )
    work = Work.find work_id
    parsed = {}

    configuration.each { |field|
      parsed[ field[ 0 ] ] = Collection.follow_json work.original, field[ 1 ]
    }

    work.update parsed: parsed

    if work.cache_thumb
      histogram = work.extract_colors
      if histogram.any?
        work.update primary_color: histogram[0][ :color ], top_colors: histogram
      end
    end

    sleep 1
  end
end

