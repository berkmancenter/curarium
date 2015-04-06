require 'spec_helper'

describe ( 'Work model' ) {
  context ( 'with valid data' ) {
    let ( :w ) { Work.first }

    it { w.should be_valid }

    it { w.should respond_to 'images' }

    it {
      # "work" annotations is a shortcut to the annotations on the work's first image
      w.should respond_to :annotations
    }

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

    it ( 'should have thumb cache path' ) {
      thumb_hash = Zlib.crc32 w.thumbnail_url
      w.thumbnail_cache_path.should eq( Rails.root.join( 'public', 'thumbnails', "#{thumb_hash}.png" ).to_s )
    }

    it ( 'should have thumb cache url' ) {
      thumb_hash = Zlib.crc32 w.thumbnail_url
      w.thumbnail_cache_url.should eq( "/thumbnails/#{thumb_hash}.png" )
    }

    it ( 'should have topics parsed from original with multiple values' ) {
      w.parsed[ 'topics' ].should eq( '["stars", "night", "churches"]' )
    }
  }

  context ( 'with empty_thumbnail' ) {
    let ( :w ) { Work.find_by_title 'empty_thumbnail' }

    it ( 'should have missing thumb cache url' ) {
      w.thumbnail_cache_url.should eq( '/missing_thumb.png' )
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

