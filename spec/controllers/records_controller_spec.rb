require 'spec_helper'

describe ( RecordsController ) {
  before {
    session[:user_id] = User.first.id
  }

  describe ( 'GET index' ) {
    context ( 'no arguments' ) {
      it {
        Record.should_receive( :all )
        get :index
        response.code.should eq( '200' )
      }
    }

    context ( 'collection records' ) {
      let ( :collection ) { Collection.first }

      it {
        Record.should_receive( :where ).with( collection_id: collection.id )
        get :index, :collection_id => collection
        response.code.should eq( '200' )
      }
    }
  }
}


