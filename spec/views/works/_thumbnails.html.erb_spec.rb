require 'spec_helper'

describe ( 'works/thumbnails' ) {
  subject { rendered }

  context ( 'all works' ) {
    let ( :works ) { Work.all }

    before {
      render partial: 'works/thumbnails', object: works
    }

    it {
      should have_css 'section.works-thumbnails'
    }

    it {
      should have_css 'a', count: works.count
    }

    it {
      # now background-images on a elements
      should_not have_css 'a img'
    }
  }
}
