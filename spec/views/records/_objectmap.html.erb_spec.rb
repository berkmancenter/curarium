require 'spec_helper'

describe ( 'records/objectmap' ) {
  subject { rendered }

  context ( 'all records' ) {
    let ( :records ) { Record.all }

    before {
      render partial: 'records/objectmap', object: records
    }

    it {
      should have_css 'section.records-objectmap'
    }

    it {
      should have_css '.records-objectmap div.geomap'
    }

    it {
      should have_css '.geomap[data-record-ids]'
    }

    it {
      should have_css %[.geomap[data-record-ids="[#{records.map { |r| r.id }.join(',')}]"]]
    }
  }
}
