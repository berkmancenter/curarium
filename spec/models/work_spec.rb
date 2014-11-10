require 'spec_helper'

describe ( 'Work model' ) {
  context ( 'with valid data' ) {
    let ( :w ) { Work.first }

    it { w.should be_valid }

    it { w.should respond_to 'images' }

    it ( 'should have an original value' ) {
      w.original.should_not eq( nil )
    }

    it ( 'should have parsed values' ) {
      w.parsed.should_not eq( nil )
    }

    it {
      w.parsed.class.should eq( Hash )
    }

    it ( 'should no longer store id in parsed' ) {
      w.parsed[ 'curarium' ].should eq( nil )
    }

    it ( 'should still have have title parsed from original (for filtering)' ) {
      w.parsed[ 'title' ].should eq( '["Starry Night"]' )
    }

    it ( 'should have parsed out the title to special attribute' ) {
      w.title.should eq( 'Starry Night' )
    }

    it ( 'should no longer have image parsed from original' ) {
      w.parsed[ 'image' ].should eq( nil )
    }

    it ( 'should no longer have thumbnail parsed from original' ) {
      w.parsed[ 'thumbnail' ].should eq( nil )
    }

    it ( 'should have thumbnail_url again (as shortcut to .images)' ) {
      w.should respond_to 'thumbnail_url'
    }

    it ( 'should have thumb' ) {
      w.thumbnail_url.should_not eq( nil )
    }

    it ( 'should have topics parsed from original with multiple values' ) {
      w.parsed[ 'topics' ].should eq( '["stars", "night", "churches"]' )
    }
  }

  describe ( 'scope with_thumb' ) {
    let ( :c ) { Collection.find_by_name 'test_col' }

    it {
      rs = c.works.with_thumb
      rs.where( { title: 'empty_thumbnail' } ).count.should eq( 0 )
    }
  }
}

