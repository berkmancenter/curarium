require 'spec_helper'

describe ( SpotlightsController ) {
  let ( :s ) { Spotlight.first }
  let ( :s_attr ) { FactoryGirl.attributes_for( :spotlight_two ) }

  context ( 'with anonymous' ) {
    # GET /spotlights/:id redirects to waku_url

    # POST/DELETE /spotlights status = 401
  }

  context ( 'with user' ) {
    let ( :u ) { User.first }

    before {
      controller.login_browserid u.email 
    }

    describe ( 'POST spotlights' ) {
      it ( 'should return ok' ) {
        post :create, spotlight: s_attr, format: :json
        response.code.should eq( '200' )
      }

      it ( 'should create a new item' ) {
        expect {
          post :create, spotlight: s_attr, format: :json
        }.to change( Spotlight, :count ).by( 1 )
      }
    }

    describe ( 'PUT spotlight' ) {
      it ( 'should return ok' ) {
        put :update, id: s.id, spotlight: { title: 'updated' }, format: :json
        response.code.should eq( '200' )
        Spotlight.first.title.should eq( 'updated' )
      }

      context ( 'with waku_id' ) {
        it ( 'should return ok' ) {
          put :update, id: s.waku_id, spotlight: { title: 'updated' }, format: :json
          response.code.should eq( '200' )
          Spotlight.first.title.should eq( 'updated' )
        }
      }
    }


    describe ( 'DELETE spotlight' ) {
      it ( 'should return ok' ) {
        delete :destroy, id: s.id, format: :json
        response.code.should eq( '204' )
      }

      it ( 'should delete an item' ) {
        expect {
          post :destroy, id: s.id, format: :json
        }.to change( Spotlight, :count ).by( -1 )
      }

      context ( 'with waku_id' ) {
        it ( 'should delete an item' ) {
          expect {
            post :destroy, id: s.waku_id, format: :json
          }.to change( Spotlight, :count ).by( -1 )
        }
      }
    }

    after {
      controller.logout_browserid
    }
  }
}
