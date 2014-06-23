require 'spec_helper'

describe ( 'layouts/application' ) {
  subject { rendered }

  context ( 'default layout' ) {
    before {
      render 
    }

    it {
      should have_title 'Curarium'
    }

    describe ( 'shared/header' ) {
      should have_css '.GLOBAL_MENU'
    }

    it {
      should have_css '.GLOBAL_HOLDER'
    }

    describe ( 'shared/header' ) {
      should have_css '.FOOTER'
    }
  }
}
