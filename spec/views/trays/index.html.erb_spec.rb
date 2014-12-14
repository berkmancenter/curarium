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
      should have_css '.GALLERY'
    }

    it {
      should_not have_css '.gallery_item'
    }

    it {
      should have_css 'h2.titlebar', text: tray.name
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
}
