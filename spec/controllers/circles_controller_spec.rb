require 'spec_helper'

describe ( CirclesController ) {
  let ( :u ) { User.first }
  let ( :c ) { Circle.find_by_title 'test_circle' }
  let ( :c_two ) { Circle.find_by_title 'circle_two' }
  let ( :c_attr ) { FactoryGirl.attributes_for( :circle_three ) }

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
      controller.login_browserid u.email 
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

      it ( 'should set user as admin' ) {
        post :create, circle: c_attr
        Circle.last.admin.should eq( u )
      }

      it ( 'should include user as circle user' ) {
        post :create, circle: c_attr
        Circle.last.users.include?( u ).should eq( true )
      }

      context ( 'with empty data' ) {
        it ( 'should not allow missing title' ) {
          expect {
            post :create, circle: { title: '', description: 'description' }
          }.to_not change( Circle, :count )
        }
      }
    }

    describe ( 'PUT join' ) {
      it ( 'should add to users if not in circle' ) {
        expect {
          put :join, id: c_two.id
        }.to change( c_two.users, :count ).by( 1 )
      }

      it ( 'should not add to users if in circle' ) {
        expect {
          put :join, id: c.id
        }.to_not change( c.users, :count )
      }
    }

    describe ( 'PUT leave' ) {
      it ( 'should remove from users if in circle' ) {
        expect {
          put :leave, id: c.id
        }.to change( c.users, :count ).by( -1 )
      }
    }

    after {
      controller.logout_browserid
    }
  }
}


