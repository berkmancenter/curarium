require 'spec_helper'

describe ( 'circles/index' ) {
  subject { rendered }

  before {
    assign( :circles, Circle.all )
    render
  }

  it {
    should have_css 'h1.collection-header', text: 'Circles'
  }

  it {
    should have_css '.GALLERY.circle-gallery'
  }

  it {
    should have_css '.circle-gallery .gallery_item'
  }

}

