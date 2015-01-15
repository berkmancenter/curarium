require 'spec_helper'

describe ( 'home/index' ) {
  subject { rendered }

  let( :works ) { Work.limit(10).order("RANDOM()") }
  let( :collection ) { Collection.limit(1).order("RANDOM()").first }
  let( :spotlights ) { Spotlight.limit(10).order("RANDOM()") }

  context ( 'with anonymous' ) {
    before {
      assign( :works, works )
      assign( :collection, collection )
      assign( :spotlights, spotlights )
      assign( :all, (works + spotlights).shuffle )

      render
    }

    it {
      should have_css '.INFO_BAR'
    }

    it {
      should have_css '.GALLERY'
    }

    it {
      # 1 gallery_item for collection + the other random selection
      should have_css '.GALLERY .gallery_item', count: 1 + (works + spotlights).count
    }

    it {
      should have_css '.beta-popup'
    }
  }

  context ( 'with signed in user' ) {
    let ( :user ) { User.first }

    before {
      session[ :browserid_email ] = user.email
      assign( :current_user, user )
      render
    }

  }
}
