require 'factory_girl_rails'

namespace :db do
  namespace :test do
    task :prepare => :environment do
      # collections
      test_col = FactoryGirl.create :test_col
    end
  end
end

