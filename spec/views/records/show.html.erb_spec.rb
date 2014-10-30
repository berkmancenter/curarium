require 'spec_helper'

describe ( 'records/show' ) {
  subject { rendered }

  let ( :work ) { Work.first }
  before {
    assign( :work, work )
    assign( :current_metadata, work.parsed )
    
    render
  }

  it {
    should have_css '.parsed-info', visible: false
  }
}
