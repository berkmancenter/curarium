require 'spec_helper'

describe ( 'spotlights/index' ) {
  subject { rendered }

  let ( :user ) { User.first }

  before {
    assign( :spotlights, Spotlight.all )
    render
  }

  it {
    should have_css 'h1.collection-header', text: 'Spotlights'
  }

  it {
    should have_css '.GALLERY.spotlight-gallery'
  }

  it {
    should have_css '.spotlight-gallery .gallery_item'
  }

  it {
    should_not have_css '.createnew'
  }

  context ( 'with user' ) {
    before {
      session[ :browserid_email ] = user.email
      assign( :current_user, user )
      render
    }

    it {
      should have_css '.createnew'
    }

    it {
      should have_css '.createnew a'
    }

    it {
      should have_css %Q|.createnew a[href*="#{Waku::URL}"]|
    }
  }
}

