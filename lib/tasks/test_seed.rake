require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      # collections
      test_col = FactoryGirl.create :test_col

      # records
      test_col.create_record_from_json FactoryGirl.attributes_for( :test_record )[ :original ]
      test_col.create_record_from_json FactoryGirl.attributes_for( :test_record_two )[ :original ]
      test_col.create_record_from_json FactoryGirl.attributes_for( :test_record_three )[ :original ]
    end
  end
end

