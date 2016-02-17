class CollectionField < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true, uniqueness: true

  scope :available_for, ->( collection ) {
    where( "NOT name IN ('#{collection.configuration.keys.join( "','" )}')" )
    
  }
end

