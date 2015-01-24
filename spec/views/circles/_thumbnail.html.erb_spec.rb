require 'spec_helper'

describe ( 'circles/thumbnail' ) {
  subject { rendered }

  let ( :c ) { Circle.first }

  before {
    render partial: 'circles/thumbnail', object: c
  }

  it {
    should have_css 'a.gallery_item'
  }

  it {
    should have_css '.gallery_item.thumbnail'
  }

  it {
    should have_css '.thumbnail span.title'
  }

  it {
    should have_css '.circle-thumbnail'
  }

  it {
    should have_css %Q|a[href="#{circle_path c}"]|
  }

  it {
    should have_css 'a img'
  }

  it {
    should have_css %Q|img[src*="#{c.thumbnail_url}"]|
  }
}

