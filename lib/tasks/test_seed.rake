require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      seed
    end
  end
end

namespace :curarium do
  task :seed => :environment do
    seed
  end
end

def crfj( col, r )
  col.create_record_from_json FactoryGirl.attributes_for( r )[ :original ]
end

def seed
  # user
  test_user = FactoryGirl.create :test_user

  # collections
  test_col = FactoryGirl.create :test_col
  test_col.admin = [ test_user.id ]
  test_col.save

  not_approved = FactoryGirl.create :not_approved
  not_approved.admin = [ test_user.id ]
  not_approved.save

  via = FactoryGirl.create :via
  via.admin = [ test_user.id ]
  via.save

  # records
  crfj test_col, :starry_night
  crfj test_col, :mona_lisa
  crfj test_col, :last_supper
  crfj test_col, :lucrezia

  crfj not_approved, :aphrodite
end

