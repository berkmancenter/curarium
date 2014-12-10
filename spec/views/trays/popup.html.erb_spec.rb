require 'spec_helper'

describe ( 'trays/popup' ) {
  subject { rendered }

  context ( 'user with tray' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }

    before {
      assign( :owner, user )
      assign( :trays, trays )
      render
    }

    it {
      should have_css 'h1', text: 'Your Trays'
    }

    it {
      should have_css 'button', count: 2
    }

    it {
      should have_css 'button.tray-popup-button', count: 2
    }
  }
}
