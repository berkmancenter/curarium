require 'spec_helper'

describe ( 'trays/index' ) {
  subject { rendered }

  context ( 'user with tray' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }
    let ( :tray ) { trays.first }
    let ( :image ) { tray.tray_items.first }

    before {
      assign( :owner, user )
      assign( :trays, trays )
      render
    }

    it {
      should have_css 'h1.collection-header', text: 'Tray Manager'
    }

    describe ( 'new tray form' ) {
      it {
        should have_css 'form[action*="trays"][method="post"]'
      }

      it {
        should have_css 'input[type="hidden"][name="tray[owner_id]"]'
      }

      it {
        should have_css 'input[type="hidden"][name="tray[owner_type]"]'
      }

      it {
        should have_css 'input[name="tray[name]"]'
      }
    }

    it {
      should have_css '.GALLERY.tray-preview-gallery'
    }

    # further tests moved to tray_preview_gallery
  }
}
