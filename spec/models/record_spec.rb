require 'spec_helper'

describe ( 'Record model' ) {
  context ( 'with valid data' ) {
    let ( :rec ) { Record.first }

    it { rec.should be_valid }

    it ( 'should have an original value' ) {
      rec.original.should_not eq( nil )
    }

    it ( 'should have parsed values' ) {
      rec.parsed.should_not eq( nil )
    }

    it ( 'should no longer store id in parsed' ) {
      rec.parsed[ 'curarium' ].should eq( nil )
    }

    it ( 'should have title parsed from original' ) {
      rec.parsed[ 'title' ].should eq( '["Starry Night"]' )
    }

    it ( 'should have thumbnail parsed from original' ) {
      rec.parsed[ 'thumbnail' ].should eq( '["http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/116px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg"]' )
    }

    it ( 'should have topics parsed from original with multiple values' ) {
      rec.parsed[ 'topics' ].should eq( '["stars", "night", "churches"]' )
    }
  }
}

