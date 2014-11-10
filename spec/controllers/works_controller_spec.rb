require 'spec_helper'

describe ( WorksController ) {
  before {
    session[:user_id] = User.first.id
  }

  describe ( 'GET index' ) {
    context ( 'no arguments' ) {
      it {
        # Work gets a where '' now, even if no arguments sent to controller
        #Work.should_receive( :where )
        get :index
        response.code.should eq( '200' )
      }
    }

    context ( 'collection works' ) {
      let ( :collection ) { Collection.first }

      it {
        #Work.should_receive( :where ).with( collection_id: collection.id )
        #Collection.should_receive( :find ).with( "#{collection.id}" )
        get :index, :collection_id => collection.id
        response.code.should eq( '200' )
      }
    }
  }

  describe ( 'GET work' ) {
    let ( :work ) { Work.first }

    it {
      get :show, :id => work.id

      response.code.should eq( '200' )

    }
  }

  describe ( 'GET work/thumb' ) {
    context ( 'normal work' ) {
      let ( :work ) { Work.first }

      describe ( 'before cache_thumbs' ) {
        before {
          Rails.cache.clear
        }

        it ( 'should now wait for & return thumbnail' ) {
          get :thumb, :id => work.id

          response.code.should eq( '200' )
        }
      }
    }

    context ( 'with missing thumbnail' ) {
      let ( :work ) { Work.where( "parsed->'title' = '[\"empty_thumbnail\"]'" ).first }

      it {
        get :thumb, :id => work.id

        response.code.should eq( '404' )
      }
    }
  }


}


