require 'spec_helper'

describe ( 'annotations/thumbnail' ) {
  subject { rendered }

  let ( :a ) { Annotation.first }

  before {
    render partial: 'annotations/thumbnail', object: a
  }

  it {
    should have_css '.thumbnail.annotation-thumbnail'
  }

  it {
    should have_css '.thumbnail span.title'
  }

  it {
    should have_css '.thumbnail img'
  }

  it {
    should have_css %Q|img[src*="#{a.thumbnail_url}"]|
  }
}

