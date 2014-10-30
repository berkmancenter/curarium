require 'spec_helper'

describe ( 'Work model' ) {
  context ( 'with valid data' ) {
    let ( :r ) { Work.first }

    it { r.should be_valid }

    it ( 'should have an original value' ) {
      r.original.should_not eq( nil )
    }

    it ( 'should have parsed values' ) {
      r.parsed.should_not eq( nil )
    }

    it {
      r.parsed.class.should eq( Hash )
    }

    it ( 'should no longer store id in parsed' ) {
      r.parsed[ 'curarium' ].should eq( nil )
    }

    it ( 'should still have have title parsed from original (for filtering)' ) {
      r.parsed[ 'title' ].should eq( '["Starry Night"]' )
    }

    it ( 'should have parsed out the title to special attribute' ) {
      r.title.should eq( 'Starry Night' )
    }

    it ( 'should no longer have thumbnail parsed from original' ) {
      r.parsed[ 'thumbnail' ].should eq( nil )
    }

    it ( 'should have parsed out the thumbnail url to special attribute' ) {
      r.should respond_to 'thumbnail_url'
      r.thumbnail_url.should eq( 'http://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/116px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg' )
    }

    it ( 'should have topics parsed from original with multiple values' ) {
      r.parsed[ 'topics' ].should eq( '["stars", "night", "churches"]' )
    }
  }

  describe ( 'scope with_thumb' ) {
    let ( :c ) { Collection.find_by_name 'test_col' }

    it {
      rs = c.records.with_thumb
      rs.where( { title: 'empty_thumbnail' } ).count.should eq( 0 )
    }
  }
}

