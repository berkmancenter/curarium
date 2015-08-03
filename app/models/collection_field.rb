class CollectionField < ActiveRecord::Base
  scope :available_for, ->( collection ) {
    where( "NOT name IN ('#{collection.configuration.keys.join( "','" )}')" )
    
  }
end

