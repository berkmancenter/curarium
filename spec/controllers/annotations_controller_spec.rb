require 'spec_helper'

describe ( AnnotationsController ) {
  context( 'with existing' ) {
    let( :w ) { Work.find_by_title 'Last Supper' }

    describe ( 'GET annotations' ) {
      it {
        get :index, work_id: w.id
        response.code.should eq( '200' )
      }
    }

    describe ( 'GET annotation' ) {
      it {
        get :show, work_id: w.id, id: w.annotations.first.id
        response.code.should eq( '200' )
      }
    }
  }

  context ( 'with user' ) {
    before {
      controller.login_browserid User.first.email 
    }

    describe ( 'POST /annotations' ) {
      let ( :work ) { Work.find_by_title 'Starry Night' }

      it ( 'should redirect back to work' ) {
        post :create, work_id: work.id, annotation: FactoryGirl.attributes_for( :star )
        response.code.should eq( '302' )
      }

      it ( 'should create a new item' ) {
        expect {
          post :create, work_id: work.id, annotation: FactoryGirl.attributes_for( :star )
        }.to change( Annotation, :count ).by( 1 )
      }
    }

    after {
      controller.logout_browserid
    }
  }
}


