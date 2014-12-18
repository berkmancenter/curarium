require 'spec_helper'

describe ( 'Image model' ) {
  context ( 'with valid data' ) {
    let ( :w ) { Work.first }
    let ( :i ) { Image.first }

    it { i.should be_valid }

    it { i.should respond_to 'image_url' }
    it { i.should respond_to 'thumbnail_url' }

    it { i.should respond_to 'work' }

    it ( 'should have image parsed from work' ) {
      i.image_url.should eq( '/test/starry_night.jpg' )
    }

    it ( 'should have thumbnail parsed from work' ) {
      i.thumbnail_url.should eq( 'http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/116px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg' )
    }

    it {
      i.work.should_not eq( nil )
      i.work.id.should eq( w.id )
    }

  }

  context ( 'with multiple images' ) {
    let ( :w ) { Work.find_by_title 'Crucifixion' }

    it ( 'should have primary thumbnail as first ' ) {
      w.thumbnail_url.should eq( 'http://nrs.harvard.edu/urn-3:VIT.BB:4627197' )
    }
  }
}
