require 'spec_helper'

describe ( 'collections/show' ) {
  subject { rendered }

  context ( 'normal collection' ) {
    let ( :collection ) { Collection.first }
    let ( :record ) { collection.records.limit(1).order("RANDOM()").first }
    let ( :records ) { collection.records.limit(5).order("RANDOM()") }
    let ( :spotlights ) { Spotlight.limit(5).order("RANDOM()") }
    let ( :all ) { (records + spotlights).shuffle }

    before {
      assign( :collection, collection )
      assign( :record, record )
      assign( :records, records )
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

    it { should have_css %Q|.col-sidebar a[href*="#{collection_records_path collection}"]| }
    it { should have_css '.col-sidebar a', text: 'Explore' }

    it {
      should have_css '.cont_spotlight'
    }

    describe ( 'latest activity' ) {
      it { 
        should have_css '.latest-activity'
      }
    }
  }
}
