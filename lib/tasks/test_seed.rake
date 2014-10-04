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

  multi_image = FactoryGirl.create :multi_image
  multi_image.admin = [ test_user.id ]
  multi_image.save

  via = FactoryGirl.create :via
  via.admin = [ test_user.id ]
  via.save

  japanese = FactoryGirl.create :japanese
  japanese.admin = [ test_user.id ]
  japanese.save

  # annotations
  jesus = FactoryGirl.create :jesus
  jesus.user = test_user
  jesus.save

  # records
  crfj test_col, :starry_night
  crfj test_col, :mona_lisa

  # record with annotation
  supper = crfj test_col, :last_supper
  supper.annotations << jesus
  supper.save

  crfj test_col, :lucrezia
  crfj test_col, :empty_thumbnail

  crfj not_approved, :aphrodite

  crfj multi_image, :crucifixion

end

