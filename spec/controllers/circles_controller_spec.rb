require 'spec_helper'

describe ( CirclesController ) {
  let ( :user ) { User.first }
  let ( :c_attr ) { FactoryGirl.attributes_for( :circle_two ) }

  context ( 'with anonymous' ) {
    describe ( 'GET circles/new') {
      it ( 'should request authentication' ) {
        get :new
        response.code.should eq( '401' )
      }
    }
  }

  context ( 'with user' ) {
    before {
      controller.login_browserid user.email 
    }

    describe ( 'POST circles' ) {
      it ( 'should return ok' ) {
        post :create, circle: c_attr
        response.code.should eq( '302' )
      }

      it ( 'should create a new item' ) {
        expect {
          post :create, circle: c_attr
        }.to change( Circle, :count ).by( 1 )
      }

      context ( 'with empty data' ) {
        it ( 'should not allow missing title' ) {
          expect {
            post :create, circle: { title: '', description: 'description' }
          }.to_not change( Circle, :count )
        }
      }
    }

    after {
      controller.logout_browserid
    }
  }
}


