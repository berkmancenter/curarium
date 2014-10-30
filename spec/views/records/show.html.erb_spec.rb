require 'spec_helper'

describe ( 'records/show' ) {
  subject { rendered }

  let ( :work ) { Work.first }
  before {
    assign( :work, record )
    assign( :current_metadata, record.parsed )
    
    render
  }

  it {
    should have_css '.parsed-info', visible: false
  }
}
