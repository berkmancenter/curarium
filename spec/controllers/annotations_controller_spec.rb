require 'spec_helper'

describe ( AnnotationsController ) {
  before {
    session[:user_id] = User.first.id
  }

  describe ( 'POST annotations' ) {
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



}


