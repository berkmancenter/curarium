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
      # removed again as of commit hash: de298652b9a600d8c360bbd2c490cdfb0d05eda4
      should_not have_css 'script', visible: false
    }

    it {
      should have_css 'section#collection_pages'
    }

    it ( 'should have our collection configuration props as vis options' ) {
      # no longer, must click Explore link
      should_not have_css '#visualization_property option', text: 'title'
      should_not have_css '#visualization_property option', text: 'artist'
    }

    it ( 'should have our collection configuration props tag links' ) {
      # no longer, must click Explore link
      should_not have_css '#properties_header a.property_link', text: 'title'
      should_not have_css '#properties_header a.property_link', text: 'artist'
    }

  }
}
