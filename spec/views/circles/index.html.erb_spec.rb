require 'spec_helper'

describe ( 'circles/index' ) {
  subject { rendered }

  let ( :user ) { User.first }

  before {
    assign( :circles, Circle.all )
    render
  }

  it {
    should have_css 'h1.collection-header', text: 'Circles'
  }

  it {
    should have_css '.GALLERY.circle-gallery'
  }

  it {
    should have_css '.circle-gallery .gallery_item'
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
  }
}

