require 'spec_helper'

describe ( 'records/object_map' ) {
  subject { rendered }

  context ( 'all records' ) {
    let ( :records ) { Record.all }

    before {
      render partial: 'records/object_map', object: records
    }

    it {
      should have_css 'section.records-object-map'
    }

    it {
      should have_css '.records-object-map div.geomap'
    }

    it {
      should have_css '.geomap[data-record-ids]'
    }

    it {
      should have_css %[.geomap[data-record-ids="[#{records.map { |r| r.id }.join(',')}]"]]
    }
  }
}
