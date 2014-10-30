require 'spec_helper'

describe ( 'records/treemap' ) {
  subject { rendered }

  context ( 'all records' ) {
    let ( :works ) { Collection.first.works }

    before {
      render partial: 'records/treemap', object: records
    }

    it {
      should have_css 'section.works-treemap'
    }

    it {
      should have_css '.works-treemap[data-property-counts]'
    }
  }
}
