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

    describe ( 'left bar' ) {
      it {
        should have_css '.left'
      }

      it {
        should have_css '.left .holder.col-sidebar'
      }

      it {
        should have_css '.col-sidebar .titlebar.main', text: 'User'
      }

      it {
        should have_css '.col-sidebar .thumbnail'
      }
    }

    it {
      should have_css 'h1.collection-header', text: "User Tray: #{tray.name}"
    }

    it {
      should have_css '.GALLERY'
    }

    it ( 'should have tray items and add record button' ) {
      # one extra for user/circle thumbnail
      should have_css '.gallery_item', count: tray.tray_items.count + 1
    }

    it ( 'should have tray item commandnail' ) {
      should have_css '.gallery_item.commandnail'
    }

    it ( 'should have new tray item button' ) {
      #10952 removed for now
      should_not have_css '.gallery_item .createnew'
    }

    it ( 'should not have a list of all trays' ) {
      # now retrieved through ajax
      should_not have_css '.tray-popup'
    }
  }
}
