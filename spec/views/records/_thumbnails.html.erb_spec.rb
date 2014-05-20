require 'spec_helper'

describe ( 'records/thumbnails' ) {
  subject { rendered }

  context ( 'all records' ) {
    let ( :records ) { Record.all }

    before {
      render partial: 'records/thumbnails', object: records
    }

    it {
      should have_css 'section.records-thumbnails'
    }

    it {
      should have_css 'a', count: records.count
    }

    it {
      should have_css 'img', count: records.count
    }
  }
}
