require 'spec_helper'

describe ( 'home/index' ) {
  subject { rendered }

  before {
    render
  }

  it {
    should have_css '.home_section'
  }

  it {
    should have_css '.home_section .even.last'
  }
}
