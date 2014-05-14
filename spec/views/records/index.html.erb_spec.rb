require 'spec_helper'

describe ( 'records/index' ) {
  subject { rendered }

  context ( 'default view' ) {
    before {
      assign( :records, Record.all )
      render
    }

    it {
      should have_css 'h1', text: 'Records'
    }
  }
}
