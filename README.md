## Welcome to Curarium

## Dependencies

* Ruby 2.0
* Rails 4.1
* PostgreSQL 9.3
* redis 2.6

## Getting Started

The following will get you going with some sample data.

### Install ImageMagick and Ensure It's In Your Path

$ mogrify --version
mogrify: command not found
(^ ImageMagick not installed or not in path)

### Install ImageMagick

* download: http://www.imagemagick.org/script/binary-releases.php
** any version will work as we exec ImageMagick rather than interacting via a gem
* may need to close shells & open new ones to get the updated path

$ mogrify --version
Version: ImageMagick 6.9.1-2 Q16 x64 2015-04-14 http://www.imagemagick.org
(^ all set)

### Install redis

* https://github.com/rgl/redis/downloads

### rails

After cloning the repository, change to the project directory. Edit config/database.yml to point to your PostgreSQL database and then run the following commands.

1. Install rails dependencies

        $ bundle install

2. Create database

        $ rake db:setup

3. Seed database with some test data to play around

        $ rake curarium:seed

4. Start web server

        $ rails s

5. Browse to localhost:3000

## Importing a Collection

1. Browse to localhost:3000

2. Sign in (you may need to create a new Mozilla Persona account)

3. Browse to http://localhost:3000/collections/new

4. Follow instructions to fill out the Collection Creator form

You should get to the new collection's page and it should have an info box that says "Collection currently importing, X records remain."

5. Importing is done using sidekiq. The new collections page just enters all the JSON files into redis. sidekiq will pull them out and actually create collection records (Work objects), download thumbnails, and extract color information. To do this, run sidekiq from your rails project folder:

        $ bundle exec sidekiq -C config/sidekiq.yml

When sidekiq is done (it won't exit, it will just stop outputting to the console; you can hit Ctrl-C to safely end it), your collection should be ready.

6. You can test that thumbnails were created by typing:

        $ ls public/thumbnails/works

You should get a list of .jpg files.

7. You can test that works have colors by typing:

        $ rails r 'puts Work.last.top_colors'
        {"#dedede"=>0.75, "#9a2211"=>0.15, "#8b93ff"=>0.1}

