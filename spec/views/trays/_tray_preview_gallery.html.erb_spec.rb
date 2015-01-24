require 'spec_helper'

describe ( 'trays/tray_preview_gallery' ) {
  subject { rendered }

  context ( 'user trays' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }
    let ( :tray ) { trays.first }

    before {
      assign( :owner, user )
      assign( :trays, trays )
      render partial: 'trays/tray_preview_gallery', object: trays
    }

    it {
      should have_css '.GALLERY.tray-preview-gallery'
    }

    it {
      should_not have_css '.gallery_item'
    }

    it {
      should have_css 'h2.titlebar', text: tray.name
    }

    it {
      should have_css 'h2.titlebar .mini-icon'
    }

    it {
      should have_css 'a.tray-preview'
    }

    it {
      should have_css %Q|a.tray-preview[href*="#{user_tray_path user, tray}"]|
    }

    it {
      should have_css '.titlebar~.tray-preview'
    }

    it {
      should have_css '.tray-preview img'
    }
  }

  context ( 'circle trays' ) {
    let ( :c ) { Circle.first }
    let ( :trays ) { c.trays }
    let ( :tray ) { trays.first }

    before {
      assign( :owner, c )
      assign( :trays, trays )
      render partial: 'trays/tray_preview_gallery', object: trays
    }

    it {
      should have_css %Q|a.tray-preview[href*="#{circle_tray_path c, tray}"]|
    }
  }
}
