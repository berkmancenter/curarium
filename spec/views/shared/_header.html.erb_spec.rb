require 'spec_helper'

describe ( 'shared/header' ) {
  subject { rendered }

  before {
    render 'shared/header'
  }

  it {
    should have_css '.GLOBAL_MENU'
  }
}
