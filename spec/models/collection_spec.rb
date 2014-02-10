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

    it ( 'should have records' ) {
      col.records.count.should > 0
    }
  }
}

