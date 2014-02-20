class Collection < ActiveRecord::Base
  before_create :generate_key

  has_many :records, dependent: :destroy
  has_many :spotlights, through: :highlights
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :configuration, presence: true
  
  def create_record_from_parsed( original, parsed )
    # create a record from original JSON and pre-parsed version
    r = self.records.new original: original, parsed: parsed
    r.save
  end
  
  def create_record_from_json( original )
    # create a record from original JSON, parse it & add it to this collection
    pr = {}
    self.configuration.each do |field|
      pr[field[0]] = self.follow_json(original, field[1])
    end
    self.create_record_from_parsed original, pr
  end

  def follow_json(structure, path)
    if structure[path[0]] != nil
      current = structure[path[0]]
      if path.length == 1
      return [current]
      else
        if (current.class == Array && path[1] == "*" )
          field = []
          limit = current.length
          for c in 0..limit
            npath = path.slice(1,path.length)
            npath[0] = c
            partial = follow_json(current,npath)
            if partial != nil
              field.push(partial[0])
            end
          end
        else
          field = follow_json(current, path.slice(1,path.length))
        end
      end
      field = field.class == Array ? field.compact : field
    return field
    else
      return nil
    end
  end
  
  def query_records(include, exclude)
    records = self.records
    unless include == nil
      include.each do |term|
        parameters = term.split(':')
        records = records.where("parsed->:field LIKE :tag",{field: parameters[0], tag: '%\"'+parameters[1]+'\"%'})
      end
    end
    unless exclude == nil
      exclude.each do |term|
        parameters = term.split(':')
        records = records.where.not("parsed->:field LIKE :tag",{field: parameters[0], tag: '%\"'+parameters[1]+'\"%'})
      end
    end
    return records
  end
  
  def list_query(include, exclude)
     query = self.query_records(include, exclude)
     records = []
     query.find_each(batch_size: 10000) do |record|
       records.push(record.id)
     end
     return records
  end
  
  def sort_properties(include, exclude, property)
    query = self.query_records(include, exclude)
    properties = {}
    query.find_each(batch_size: 10000) do |record|
      parsed = record.parsed[property]
      if parsed == nil
        next
      end
      fields = eval(parsed)
      fields.each do |p|
      if(properties[p] == nil)
        properties[p] = 1
       else
        properties[p] = properties[p] + 1
       end
      end
    end
    return {length: query.length, properties: properties}
  end
  
  private

  def generate_key
    self[:key] = SecureRandom.base64
  end
end
