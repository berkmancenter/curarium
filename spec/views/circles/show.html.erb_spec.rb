require 'spec_helper'

describe ( 'circles/show' ) {
  subject { rendered }

  let ( :c ) { Circle.first }

  before {
    assign( :circle, c )
    render
  }

  it {
    should have_css 'h1.collection-header', text: c.title
  }

  it {
    should have_css 'section.circle-trays'
  }

  it {
    should have_css 'h1.collection-header', text: 'Trays'
  }

  it {
    should have_css '.tray-preview'
  }

  it {
    should have_css %Q|a[href*="#{circle_trays_path c}"]|, text: 'Tray Manager'
  }
}
