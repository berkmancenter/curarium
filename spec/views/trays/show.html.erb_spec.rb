require 'spec_helper'

describe ( 'trays/show' ) {
  subject { rendered }

  context ( 'user with tray' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }
    let ( :tray ) { trays.first }
    let ( :image ) { tray.tray_items.first }

    before {
      assign( :owner, user )
      assign( :trays, trays )
      assign( :tray, tray )
      render
    }

    it {
      should have_css 'h1.collection-header', text: "Tray: #{tray.name}"
    }

    it {
      should have_css '.GALLERY'
    }

    it ( 'should have tray item and add record button' ) {
      should have_css '.gallery_item', count: 2
    }

    it ( 'should have tray item commandnail' ) {
      should have_css '.gallery_item.commandnail'
    }

    it ( 'should have tray item commandnail & buttons' ) {
      should have_css '.commandnail:first a', count: 3
    }
  }
}
