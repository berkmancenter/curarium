require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      # user
      test_user = FactoryGirl.create :test_user

      # collections
      test_col = FactoryGirl.create :test_col
      test_col.admin = [ test_user.id ]

      not_approved = FactoryGirl.create :not_approved
      not_approved.admin = [ test_user.id ]
      not_approved.save

      # records
      crfj test_col, :test_record
      crfj test_col, :test_record_two
      crfj test_col, :test_record_three
    end

    def crfj( col, r )
      col.create_record_from_json FactoryGirl.attributes_for( r )[ :original ]
    end
  end
end

