require 'spec_helper'

describe ( 'trays/index' ) {
  subject { rendered }

  context ( 'user with trays' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }

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
        should have_css %Q|form[action*="#{user_trays_path user}"][method="post"]|
      }

      it {
        should have_css 'input[type="hidden"][name="tray[owner_id]"]'
      }

      it {
        should have_css 'input[type="hidden"][name="tray[owner_type]"][value="User"]'
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

  context ( 'circle with trays' ) {
    let ( :c ) { Circle.first }
    let ( :trays ) { c.trays }

    before {
      assign( :owner, c )
      assign( :trays, trays )
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
        should have_css '.col-sidebar .titlebar.main', text: 'Circle'
      }

      it {
        should have_css '.col-sidebar .thumbnail'
      }
    }

    describe ( 'main content' ) {
      it {
        should have_css '.expandable h1'
      }

      it {
        should have_css 'h1.collection-header', text: 'Tray Manager'
      }

      describe ( 'new tray form' ) {
        it {
          should have_css %Q|form[action*="#{circle_trays_path c}"][method="post"]|
        }

        it {
          should have_css 'input[type="hidden"][name="tray[owner_id]"]'
        }

        it {
          should have_css 'input[type="hidden"][name="tray[owner_type]"][value="Circle"]'
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
}
