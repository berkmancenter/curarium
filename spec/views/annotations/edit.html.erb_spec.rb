require 'spec_helper'

describe ( 'annotations/edit' ) {
  subject { rendered }

  let ( :user ) { User.first }
  let ( :a ) { Annotation.first }
  let ( :w ) { a.work }

  before {
    # can only get here if signed in
    session[ :browserid_email ] = user.email
    assign( :current_user, user )

    assign( :annotation, a )
    assign( :work, w )
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
      should have_css '.col-sidebar .titlebar.main', text: 'Annotation'
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
      should have_css 'h1.collection-header', 'Edit Annotation'
    }
  }
}

