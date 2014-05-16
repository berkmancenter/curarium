require 'spec_helper'

describe ( 'records/index' ) {
  subject { rendered }

  context ( 'all records' ) {
    before {
      assign( :records, Record.all )
      render
    }

    it {
      should have_css 'h1', text: 'Records'
    }
  }

  context ( 'in a collection' ) {
    let ( :collection ) { Collection.first }

    before {
      assign( :collection, collection )
      assign( :records, collection.records )
      render
    }

    it {
      should have_css 'h1', text: "Records for #{collection.name}"
    }
  }

  describe ( '?vis=list' ) {
    # ?vis=list is not required, list is the default vis for records

    before {
      assign( :records, Record.all )
      render
    }

    it {
      should have_css '.records-list'
    }
  }
}
