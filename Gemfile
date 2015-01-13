source 'http://rubygems.org'
ruby '2.0.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.12'

#use postgresql
gem 'pg'#, '~> 0.18.0.pre20141117110243'

group :test do
  gem 'rspec-rails', '2.14.2'
  gem 'capybara', '2.3.0'
  gem 'poltergeist', '1.5.1'
end

gem 'factory_girl_rails' #breaks rake if its only in test group

#required for Heroku
gem 'rails_12factor'

#use Devise for authentication (not implemented yet)
#gem 'devise'
gem 'browserid-rails', :git => 'git@github.com:dbp/browserid-rails.git'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use jquery-ui
gem 'jquery-ui-rails'

#Use d3 for visualizations
gem 'd3-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# bcrypt-ruby was renamed to bcrypt, has_secure_password seems to want both?
gem 'bcrypt'
gem 'bcrypt-ruby', '~> 3.1.2'

#running jobs as back processes 
gem 'sucker_punch' #does not require additional workers or redis on Heroku
gem 'rubyzip' #unzip things

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
