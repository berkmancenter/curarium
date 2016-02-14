# This file should contain all the work creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Delete all old collection data & thumbnails

FileUtils.rm_rf Rails.root.join( 'db', 'collection_data' )
FileUtils.rm_rf Rails.public_path.join( 'thumbnails' )

CollectionField.create name: 'unique_identifier', display_name: 'Unique Identifier', special: true
CollectionField.create name: 'title', display_name: 'Title', special: true
CollectionField.create name: 'image', display_name: 'Image', special: true
CollectionField.create name: 'thumbnail', display_name: 'Thumbnail Image', special: true
CollectionField.create name: 'date_start', display_name: 'Date Start', special: true
CollectionField.create name: 'date_end', display_name: 'Date End', special: true

