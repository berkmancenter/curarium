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
    let ( :original ) { '{"title":"Starry Night"}' }

    it {
      Collection.follow_json( original, ['title'] ).should eq( ['Starry Night'] )
    }
  }

  describe ( 'create_record' ) {
    let ( :rec_json ) { FactoryGirl.attributes_for( :starry_night ) }

    context ( 'from_json' ) {
      it {
        expect {
          col.create_record_from_json( rec_json[ :original ] )
        }.to change { col.records.count }.by( 1 )
      }

      describe ( 'create_record_from_json' ) {
        before {
          col.create_record_from_json( rec_json[ :original ] )
        }

        it {
          Record.last.parsed[ 'title' ].should eq( '["Starry Night"]' )
        }
      }
    }

    context ( 'from_parsed' ) {
      let ( :pr ) {
        pr = {}
        col.configuration.each do |field|
          pr[field[0]] = Collection.follow_json(rec_json[ :original ], field[1])
        end
        pr
      }

      it {
        expect {
          col.create_record_from_parsed( rec_json[ :original ], pr, 'fake_unique_id' )
        }.to change { col.records.count }.by( 1 )
      }

      context ( 'static function' ) {
        it {
          expect {
            Collection.create_record_from_parsed( col.key, rec_json[ :original ], pr, 'fake_unique_id' )
          }.to change { col.records.count }.by( 1 )
        }

        describe ( 'cache thumbnail' ) {
          before {
            Rails.cache.clear
            Collection.create_record_from_parsed( col.key, rec_json[ :original ], pr, 'fake_unique_id' )
          }

          it ( 'should cache today' ) {
            record = Record.last
            thumb_url = JSON.parse( record.parsed[ 'thumbnail' ] )[ 0 ]
            thumb_hash = Zlib.crc32 thumb_url

            cache_date = Rails.cache.fetch( "#{thumb_hash}-date" ) { Date.new }
            cache_date.should eq( Date.today )
          }
        }
      }
    }

  }
}

