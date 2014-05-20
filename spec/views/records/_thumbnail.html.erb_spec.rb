require 'spec_helper'

describe ( 'records/thumbnail' ) {
  subject { rendered }

  context ( 'normal record' ) {
    let ( :record ) { Record.first }

    before {
      assign( :record, record )
      render 'records/thumbnail', thumbnail: record
    }

    it {
      should have_css "a"
    }

    it {
      should have_css "a[href*='#{record_path record}']" 
    }

    it {
      should have_css "a[title='#{JSON.parse( record.parsed['title'] )[0]}']"
    }
  }
}
