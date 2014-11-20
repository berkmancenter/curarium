require 'spec_helper'

describe ( 'trays/index' ) {
  subject { rendered }

  context ( 'user with tray' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }
    let ( :image ) { trays.first.tray_items.first }

    before {
      assign( :owner, user )
      assign( :trays, trays )
      render
    }

    it {
      should have_css 'h1.collection-header', text: 'Tray Manager'
    }

    it {
      should have_css '.GALLERY'
    }

    it {
      should_not have_css '.gallery_item'
    }

    it {
      should have_css 'h2.titlebar', text: trays.first.name
    }

    it {
      should have_css 'a.tray-preview'
    }

    it {
      should have_css '.titlebar~.tray-preview'
    }

    it {
      should have_css '.tray-preview img'
    }
  }
}
