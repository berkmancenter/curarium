require 'spec_helper'

describe ( 'collections/show' ) {
  subject { rendered }

  context ( 'normal collection' ) {
    let ( :col ) { Collection.first }

    before {
      assign( :collection, col )
      render
    }

    it {
      should_not have_css 'script', visible: false
    }

    it {
      should have_css 'section#collection_pages'
    }
  }
}
