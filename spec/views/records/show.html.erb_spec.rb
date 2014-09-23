require 'spec_helper'

describe ( 'records/show' ) {
  subject { rendered }

  let ( :record ) { Record.first }
  before {
    assign( :record, record )
    assign( :current_metadata, record.parsed )
    
    render
  }

  it {
    should have_css '.parsed-info', visible: false
  }
}
