require 'spec_helper'

describe ( 'records/treemap' ) {
  subject { rendered }

  context ( 'all records' ) {
    let ( :records ) { Collection.first.records }

    before {
      render partial: 'records/treemap', object: records
    }

    it {
      should have_css 'section.records-treemap'
    }

    it {
      should have_css '.records-treemap[data-property-counts]'
    }
  }
}
