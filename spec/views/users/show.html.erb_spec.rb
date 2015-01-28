require 'spec_helper'

describe ( 'users/show' ) {
  subject { rendered }

  let ( :user ) { User.first }

  before {
    assign( :user, user )
    session[ :browserid_email ] = user.email
    assign( :current_user, user )

    assign( :trays, user.trays )
    render
  }

  it {
    should have_css 'h1.collection-header', text: user.name
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

  it {
    should have_css 'section.user-collections'
  }

  it {
    should have_css 'h1.collection-header', text: 'Collections'
  }

}
