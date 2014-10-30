require 'spec_helper'
require 'zlib'

describe ( 'Collection model' ) {
  let ( :col ) { Collection.find_by_name( 'test_col' ) }

  context ( 'with valid data' ) {
    it { col.should be_valid }

    it ( 'should have generated a key' ) {
      col.key.length.should_not eq( 0 )
    }

    it ( 'should have a configuration' ) {
      col.configuration.should_not eq( nil )
    }

    it ( 'should specify a title field in configuration' ) {
      col.configuration[ 'title' ].present?.should be_true
    }

    it ( 'should no longer have properties' ) {
      col.should_not respond_to 'properties'
    }

    it ( 'should have records' ) {
      col.records.count.should > 0
    }
  }

  describe ( 'update configuration' ) {
    it ( 'should no longer reset properties' ) {
      col.configuration = '{"no_title":["titleInfo",0,"title",0],"image":["relatedItem","*","content","location",0,"url",0,"content"],"thumbnail":["relatedItem","*","content","location",0,"url",1,"content"]}'
      col.changed.include?( 'configuration' ).should be_true
      col.should_not respond_to 'properties' # not saved yet
      col.save
      col.should_not respond_to 'properties'
    }
  }

  describe ( 'Collection.follow_json' ) {
    let ( :original ) { '{"title":"Starry Night","relatedItem":[{"image":"http://image.com/0","thumbnail":"http://thumbnail.com/0"},{"image":"http://image.com/1","thumbnail":"http://thumbnail.com/1"}]}' }

    it ( 'should return array even for non-* config' ) {
      value = Collection.follow_json( original, [ 'title' ] )
      value.class.should eq( Array )
      value[ 0 ].should eq( 'Starry Night' )
    }

    it ( 'should return array for * config' ) {
      value = Collection.follow_json( original, [ 'relatedItem', '*', 'image' ] )
      value.class.should eq( Array )
      value[ 0 ].should eq( 'http://image.com/0' )
      value[ 1 ].should eq( 'http://image.com/1' )
    }

    it ( 'should return nil for missing properties' ) {
      Collection.follow_json( original, [ 'foo' ] ).should eq( nil )
    }

    describe ( 'follow_json_single' ) {
      it ( 'should return single value for non-* config' ) {
        Collection.follow_json_single( original, [ 'title' ] ).should eq( 'Starry Night' )
      }

      it ( 'should return first array value for * config' ) {
        Collection.follow_json_single( original, [ 'relatedItem', '*', 'image' ] ).should eq( 'http://image.com/0' )
      }

      it ( 'should return nil for missing properties' ) {
        Collection.follow_json_single( original, [ 'foo' ] ).should eq( nil )
      }
    }
  }

  describe ( 'create_record' ) {
    let ( :r ) { FactoryGirl.attributes_for( :starry_night ) }

    context ( 'from_json' ) {
      it {
        expect {
          col.create_record_from_json( r[ :original ] )
        }.to change { col.records.count }.by( 1 )
      }

      describe ( 'create_record_from_json' ) {
        before {
          col.create_record_from_json( r[ :original ] )
        }

        it {
          Work.last.title.should eq( 'Starry Night' )
        }

        it ( 'should extract thumbnail_url' ) {
          Work.last.thumbnail_url.should eq( 'http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/116px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg' )
          Work.last.parsed[ 'thumbnail' ].should eq( nil )
        }
      }

      describe ( 'return a record' ) {
        it {
          col.create_record_from_json( r[ :original ] ).class.should eq( Work.first.class )
        }
      }
    }

    context ( 'from_parsed' ) {
      let ( :pr ) {
        pr = {}
        col.configuration.each do |field|
          pr[field[0]] = Collection.follow_json(r[ :original ], field[1])
        end
        pr
      }

      it {
        expect {
          col.create_record_from_parsed r[ :original ], pr
        }.to change { col.records.count }.by( 1 )
      }

      describe ( 'return a record' ) {
        it {
          col.create_record_from_parsed( r[ :original ], pr ).class.should eq( Work.first.class )
        }
      }

      context ( 'static function' ) {
        it {
          expect {
            Collection.create_record_from_parsed( col.key, r[ :original ], pr )
          }.to change { col.records.count }.by( 1 )
        }

        describe ( 'return a record' ) {
          it {
            Collection.create_record_from_parsed( col.key, r[ :original ], pr ).class.should eq( Work.first.class )
          }
        }

        describe ( 'no longer caching thumbnail on record creation' ) {
          before {
            Rails.cache.clear
            Collection.create_record_from_parsed( col.key, r[ :original ], pr )
          }

          it ( 'should not have cache date yet' ) {
            r = Work.last
            thumb_hash = Zlib.crc32 r.thumbnail_url

            cache_date = Rails.cache.fetch( "#{thumb_hash}-date" ) { Date.new }
            cache_date.should eq( Date.new )
          }
        }
      }
    }

  }
}

