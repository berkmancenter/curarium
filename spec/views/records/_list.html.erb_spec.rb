require 'spec_helper'

describe ( 'records/list' ) {
  subject { rendered }

  context ( 'all records' ) {
    let ( :records ) { Record.all }

    before {
      render partial: 'records/list', object: records
    }

    it {
      should have_css 'ul.records-list'
    }

    it {
      should have_css 'li', count: records.count
    }
  }
}
