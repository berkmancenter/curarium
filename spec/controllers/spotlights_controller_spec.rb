require 'spec_helper'

describe ( SpotlightsController ) {
  let ( :s ) { Spotlight.first }
  let ( :s_attr ) { FactoryGirl.attributes_for( :spotlight_two }

  context ( 'with anonymous' ) {
    # GET /spotlights/:id redirects to waku_url

    # POST/DELETE /spotlights status = 401
  }

  context ( 'with user' ) {
    let ( :u ) { User.first }

    before {
      controller.login_browserid u.email 
    }

    describe ( 'POST spotlight' ) {
      it ( 'should return ok' ) {
        post :create, spotlight: s_attr
        response.code.should eq( '200' )
      }

      it ( 'should create a new item' ) {
        expect {
          post :create, spotlight: s_attr
        }.to change( Spotlight, :count ).by( 1 )
      }
    }

    describe ( 'DELETE spotlight' ) {
      it ( 'should return ok' ) {
        post :destroy, id: s.id
        response.code.should eq( '200' )
      }

      it ( 'should create a new item' ) {
        expect {
          post :destroy, id: s.id
        }.to change( Spotlight, :count ).by( -1 )
      }
    }

    after {
      controller.logout_browserid
    }
  }
}
