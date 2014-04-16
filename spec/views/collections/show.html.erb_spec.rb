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
      # javascript is back in html, as single call to collection.show
      should have_css 'script', visible: false
    }

    it {
      should have_css 'section#collection_pages'
    }

    it ( 'should have our collection configuration props as vis options' ) {
      should have_css '#visualization_property option', text: 'title'
      should have_css '#visualization_property option', text: 'artist'
    }

    it ( 'should have our collection configuration props tag links' ) {
      should have_css '#properties_header a.property_link', text: 'title'
      should have_css '#properties_header a.property_link', text: 'artist'
    }

  }
}
