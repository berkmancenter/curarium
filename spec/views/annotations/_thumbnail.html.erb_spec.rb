require 'spec_helper'

describe ( 'annotations/thumbnail' ) {
  subject { rendered }

  let ( :a ) { Annotation.first }
  let ( :w ) { a.work }

  before {
    render partial: 'annotations/thumbnail', object: a
  }

  it {
    should have_css %Q|a[href*="#{work_annotation_path w, a }"]|
  }

  it {
    should have_css 'a.gallery_item'
  }

  it {
    should have_css '.gallery_item.thumbnail'
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

