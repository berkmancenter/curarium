require 'spec_helper'

describe ( RecordsController ) {
  before {
    session[:user_id] = User.first.id
  }

  describe ( 'GET index' ) {
    context ( 'no arguments' ) {
      it {
        # Record gets a where '' now, even if no arguments sent to controller
        Record.should_receive( :where )
        get :index
        response.code.should eq( '200' )
      }
    }

    context ( 'collection records' ) {
      let ( :collection ) { Collection.first }

      it {
        #Record.should_receive( :where ).with( collection_id: collection.id )
        #Collection.should_receive( :find ).with( "#{collection.id}" )
        get :index, :collection_id => collection.id
        response.code.should eq( '200' )
      }
    }
  }

  describe ( 'GET record' ) {
    let ( :record ) { Record.first }

    it {
      get :show, :id => record.id

      response.code.should eq( '200' )

    }
  }

  describe ( 'GET record/thumb' ) {
    let ( :record ) { Record.first }

    it {
      get :thumb, :id => record.id

      response.code.should eq( '200' )
    }
  }


}


