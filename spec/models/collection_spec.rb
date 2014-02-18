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

    it ( 'should have properties' ) {
      col.properties.should_not eq( nil )
    }

    it ( 'should have a property for the title configuration field' ) {
      col.properties[ 'title' ].should_not eq( nil )
    }

    it ( 'should know that only one record has the title "Starry Night"' ) {
      col.properties[ 'title' ][ 'Starry Night' ].should eq( 1 )
    }

    it ( 'should have records' ) {
      col.records.count.should > 0
    }
  }

  describe ( 'update configuration' ) {
    let ( :col ) { Collection.find_by_name( 'test_col' ) }

    it ( 'should reset properties' ) {
      col.configuration = '{"no_title":["titleInfo",0,"title",0],"image":["relatedItem","*","content","location",0,"url",0,"content"],"thumbnail":["relatedItem","*","content","location",0,"url",1,"content"]}'
      col.changed.include?( 'configuration' ).should be_true
      col.properties[ 'title' ].should_not eq( nil ) # not saved yet
      col.save
      col.properties[ 'title' ].should eq( nil )
      col.properties[ 'no_title' ].should_not eq( nil )
    }
  }
}

