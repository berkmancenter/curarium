require 'spec_helper'

describe ( 'works/treemap' ) {
  subject { rendered }

  context ( 'all works' ) {
    let ( :works ) { Collection.first.works }

    before {
      render partial: 'works/treemap', object: works
    }

    it {
      should have_css 'section.works-treemap'
    }

    it {
      should have_css '.works-treemap[data-property-counts]'
    }
  }
}
