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
  col.create_work_from_json FactoryGirl.attributes_for( r )[ :original ]
end

def seed
  # user
  test_user = FactoryGirl.create :test_user
  user_two = FactoryGirl.create :user_two

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

  # works
  crfj test_col, :starry_night
  crfj test_col, :mona_lisa

  # work with annotation
  supper = crfj test_col, :last_supper
  supper.images.first.annotations << jesus
  supper.images.first.save
  supper.save

  crfj test_col, :lucrezia
  crfj test_col, :empty_thumbnail

  crfj not_approved, :aphrodite

  crfj multi_image, :crucifixion

  # circles
  test_circle = FactoryGirl.create :test_circle
  test_circle.admin = test_user
  test_circle.users << [ test_user, user_two ]
  test_circle.save

  circle_two = FactoryGirl.create :circle_two
  circle_two.admin = user_two
  circle_two.users << user_two
  circle_two.save

  # trays
  test_tray = FactoryGirl.create :test_tray
  test_tray.owner = test_user
  test_tray.images << Image.first
  test_tray.annotations << Annotation.first
  test_tray.save

  empty_tray = FactoryGirl.create :empty_tray
  empty_tray.owner = test_user
  empty_tray.save

  circle_tray = FactoryGirl.create :circle_tray
  circle_tray.owner = test_circle
  circle_tray.images << Work.find_by_title( 'Aphrodite Pudica' ).images.first
  circle_tray.save

  # spotlights
  test_spotlight = FactoryGirl.create :test_spotlight
  test_spotlight.user = test_user
  test_spotlight.save
end

