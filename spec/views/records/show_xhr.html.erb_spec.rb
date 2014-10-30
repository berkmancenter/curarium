require 'spec_helper'

describe ( 'records/show_xhr' ) {
  subject { rendered }

  let ( :work ) { Work.first }
  before {
    assign( :work, record )
    assign( :current_metadata, record.parsed )
    
    render template: 'records/show_xhr', layout: false
  }

  it {
    should have_css 'h1', visible: false
  }

  it {
    should_not have_css '.GLOBAL_MENU'
  }

  it {
    should have_css '.parsed-info'
  }

  it {
    should have_css '.work-image'
  }

  it {
    should have_css '.work-image .work-commands'
    should have_css ".work-commands a[href*='#{record_path record}'].show"
    should have_css '.work-commands a.close'
  }

  it {
    should have_css '.work-image img'
  }

  it {
    should have_css '.surrogates'
  }

  it {
    should have_css '.surrogates a'
  }

  it {
    should have_css '.surrogates a img'
  }
}
