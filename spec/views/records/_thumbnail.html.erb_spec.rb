require 'spec_helper'

describe ( 'records/thumbnail' ) {
  subject { rendered }

  context ( 'normal record' ) {
    let ( :record ) { Record.first }

    before {
      assign( :record, record )
      render 'records/thumbnail', record: record
    }

    it {
      should have_css "a.record_thumbnail" 
    }

    it {
      should have_css "a[href*='#{record_path record}']" 
    }

    it {
      should have_css 'h3.record_thumbnail_title', text: JSON.parse( record.parsed['title'] )[0]
    }
  }
}
