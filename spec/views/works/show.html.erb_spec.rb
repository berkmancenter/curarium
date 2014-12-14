require 'spec_helper'

describe ( 'works/show' ) {
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

  it {
    should have_css '.expand_tray', visible: false
  }
}
