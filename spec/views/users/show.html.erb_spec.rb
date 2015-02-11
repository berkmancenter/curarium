require 'spec_helper'

describe ( 'users/show' ) {
  let ( :user ) { User.first }

  subject { rendered }

  before {
    assign( :user, user )
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

    it {
      should have_css '.col-sidebar .stalking_menu_holder'
    }

    it {
      should have_css '.stalking_menu_holder .stalking_menu'
    }

    it {
      should have_css '.stalking_menu a[href="#user-bio"]'
    }

    it {
      should have_css '.stalking_menu a[href="#user-collections"]'
    }
  }

  describe ( 'main content' ) {
    it {
      should have_css '.expandable h1'
    }

    it {
      should have_css 'h1#user-bio.collection-header', text: user.name
    }

    it {
      should have_css 'dd', text: user.bio
    }

    it {
      should_not have_css 'section.user-trays'
    }

    it {
      should_not have_css 'section.user-circles'
    }

    it {
      should have_css 'section.user-collections'
    }

    it {
      should have_css 'h1#user-collections.collection-header', text: 'Collections'
    }

    context ( 'with user signed in' ) {
      before {
        session[ :browserid_email ] = user.email
        assign( :current_user, user )

        render
      }

      it {
        should have_css 'section.user-trays'
      }

      it {
        should have_css 'h1.collection-header', text: 'Trays'
      }

      it {
        should have_css '.tray-preview'
      }

      it {
        should have_css %Q|a[href*="#{user_trays_path user}"]|, text: 'Tray Manager'
      }

      it {
        should have_css 'section.user-circles'
      }

      it {
        should have_css 'h1.collection-header', text: 'Circles'
      }

      it {
        should have_css %Q|a[href*="#{circles_path}"]|, text: 'Circle Manager'
      }

      it {
        should have_css '.user-circles .GALLERY.circle-gallery'
      }

      it {
        should have_css '.circle-gallery .gallery_item'
      }
    }
  }
}
