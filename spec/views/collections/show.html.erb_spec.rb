require 'spec_helper'

describe ( 'collections/show' ) {
  subject { rendered }

  context ( 'normal collection' ) {
    let ( :collection ) { Collection.first }
    let ( :work ) { collection.works.limit(1).order("RANDOM()").first }
    let ( :works ) { collection.works.limit(5).order("RANDOM()") }
    let ( :spotlights ) { Spotlight.limit(5).order("RANDOM()") }
    let ( :all ) { (works + spotlights).shuffle }

    before {
      assign( :collection, collection )
      assign( :work, work )
      assign( :works, works )
      assign( :spotlights, spotlights )
      assign( :all, all )
      render
    }

    it {
      # removed again as of commit hash: de298652b9a600d8c360bbd2c490cdfb0d05eda4
      should_not have_css 'script', visible: false
    }

    it {
      should have_css '.col-sidebar'
    }

    it { should have_css %Q|.col-sidebar a[href*="#{collection_works_path collection}"]| }
    it { should have_css '.col-sidebar a', text: 'Explore' }

    it {
      should have_css '.cont_spotlight'
    }

    describe ( 'latest activity' ) {
      it { 
        should have_css '.latest-activity'
      }

      it {
        should have_css '.activity_holder'
      }

      it {
        should have_css '.activity_holder .date', text: collection.created_at.strftime( '%d.%m.%y' )
      }

      it {
        should have_css '.activity_holder .activity', text: 'Test User created this collection'
      }
    }
  }
}
