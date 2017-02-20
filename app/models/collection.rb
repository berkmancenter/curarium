class Collection < ActiveRecord::Base
  has_many :collection_admins
  has_many :admins, through: :collection_admins

  has_many :works, dependent: :destroy
  has_many :spotlights, through: :highlights

  has_many :circle_collections
  has_many :circles, through: :circle_collections
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :source, presence: true

  scope :administered_by, ->( user ) {
    where( "id IN ( SELECT collection_id FROM collection_admins WHERE user_id = #{user.id} )" )
  }

  scope :with_works, -> {
    where "id in ( select distinct collection_id from works )"
  }

  after_initialize :init

  def init
    self.configuration ||= { 
      'unique_identifier' => '',
      'title' => '',
      'image' => '',
      'thumbnail' => '',
      'date_start' => '',
      'date_end' => ''
    }
  end

  def cover
    if cover_id.present?
      Work.find cover_id
    elsif works.with_thumb.any?
      works.with_thumb.first
    end
  end

  def cover=( c )
    self.cover_id = c.id
  end

  def cover_url
    cover.present? ? cover.thumbnail_cache_url : Work.missing_thumb_url
  end
  
  def self.is_i?( str )
    # fast way to test if string is simple, positive, base 10 number
    str.to_i.to_s == str
  end

  def self.create_work_from_parsed( key, original, parsed )
    # create a work from original JSON and pre-parsed version
    col = find_by_key key
    col.create_work_from_parsed original, parsed
  end

  def self.follow_json( structure, path )
    Rails.logger.debug "[reconfigure] path: #{path}"

    if structure.is_a? String
      structure = JSON.parse structure
    end

    cpath = path[0]
    cpath = cpath.to_i if is_i?( cpath )

    field = nil

    if path.count > 0 && structure.present? && structure[cpath].present?
      current = structure[cpath]

      if path.length == 1
        field = [ current ]
      else
        if current.class == Array && path[1] == '*'
          field = []
          limit = current.length
          for c in 0..limit
            npath = path.slice 1, path.length
            npath[0] = c
            partial = follow_json current, npath
            if partial.present?
              field.push partial[ 0 ]
            end
          end
        else
          field = follow_json current, path.slice( 1, path.length )
        end

        field.compact unless field.nil?
      end
    end

    Rails.logger.debug "[reconfigure] field value: #{field}"
    field
  end

  def self.follow_json_single( structure, path )
    value = follow_json structure, path
    value[ 0 ] unless value.nil?
  end

  def create_work_from_parsed( original, parsed )
    # create a work from original JSON and pre-parsed version

    r = self.works.new( {
      original: original,
      parsed: parsed
    } )
    r.save
    r
  end
  
  def create_work_from_json( original )
    # create a work from original JSON, parse it & add it to this collection
    pr = {}

    self.configuration.each do |field|
      pr[field[0]] = Collection.follow_json(original, field[1])
    end
    self.create_work_from_parsed original, pr
  end
  
  def query_works(include, exclude)
    works = self.works
    unless include == nil
      include.each do |term|
        parameters = term.split(':')
        works = works.where("parsed->:field LIKE :tag",{field: parameters[0], tag: '%\"'+parameters[1]+'\"%'})
      end
    end
    unless exclude == nil
      exclude.each do |term|
        parameters = term.split(':')
        works = works.where.not("parsed->:field LIKE :tag",{field: parameters[0], tag: '%\"'+parameters[1]+'\"%'})
      end
    end
    return works
  end
  
  def list_query(include, exclude)
     query = self.query_works(include, exclude)
     works = []
     query.find_each(batch_size: 10000) do |work|
       works.push(work.id)
     end
     return works
  end
  
  def sort_properties(include, exclude, property, minimum=0)
    query = self.query_works(include, exclude)
    properties = {}
    query.find_each(batch_size: 10000) do |work|
      parsed = work.parsed[property]
      if parsed == nil
        next
      end
      fields = JSON.parse(parsed)
      fields.each do |p|
      if(properties[p] == nil)
        properties[p] = 1
       else
        properties[p] = properties[p] + 1
       end
      end
    end
    if minimum > 1
      others = 0
      properties.each do |key, value|
        if value < minimum
          others += value
          properties.delete(key)
        end
      end
      properties["OTHER, less than #{minimum}"] = others
    end
    return {length: query.length, properties: properties}
  end
  
  def importing
    import_queue_count > 0
  end

  def import_queue_count
    begin
      Sidekiq::Queue.new.count { |i| i.args[0] == id } + Sidekiq::RetrySet.new.count { |rs| rs.args[0] == id }
    rescue Redis::CannotConnectError => e
      0
    end
  end
end
