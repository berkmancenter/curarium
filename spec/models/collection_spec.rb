require 'spec_helper'

describe ( 'Collection model' ) {
  context ( 'with valid data' ) {
    let ( :col ) { Collection.find_by_name( 'test_col' ) }

    it { col.should be_valid }

    it ( 'should have generated a key' ) {
      col.key.length.should_not eq( 0 )
    }

    it ( 'should have a configuration' ) {
      col.configuration.should_not eq( nil )
    }

    it ( 'should specify a title field in configuration' ) {
      col.configuration[ 'title' ].present?.should be_true
    }

    it ( 'should no longer have properties' ) {
      col.should_not respond_to 'properties'
    }

    it ( 'should have records' ) {
      col.records.count.should > 0
    }
  }

  describe ( 'update configuration' ) {
    let ( :col ) { Collection.find_by_name( 'test_col' ) }

    it ( 'should no longer reset properties' ) {
      col.configuration = '{"no_title":["titleInfo",0,"title",0],"image":["relatedItem","*","content","location",0,"url",0,"content"],"thumbnail":["relatedItem","*","content","location",0,"url",1,"content"]}'
      col.changed.include?( 'configuration' ).should be_true
      col.should_not respond_to 'properties' # not saved yet
      col.save
      col.should_not respond_to 'properties'
    }
  }
}

