require 'spec_helper'

describe ( TraysController ) {
  let ( :user ) { User.first }

  before {
    controller.login_browserid user.email 
  }

  describe ( 'GET users/:id/trays') {
    it ( 'should return ok' ) {
      get :index, user_id: user.id
      response.code.should eq( '200' )
    }
  }

  describe ( 'GET users/:id/trays.json') {
    it ( 'should return ok' ) {
      get :index, user_id: user.id, format: :json
      response.code.should eq( '200' )
    }
  }

}

