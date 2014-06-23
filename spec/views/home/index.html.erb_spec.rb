require 'spec_helper'

describe ( 'home/index' ) {
  subject { rendered }

  let( :records ) { Record.limit(10).order("RANDOM()") }
  let( :collection ) { Collection.limit(1).order("RANDOM()").first }
  let( :spotlights ) { Spotlight.limit(10).order("RANDOM()") }

  before {
    assign( :records, records )
    assign( :collection, collection )
    assign( :spotlights, spotlights )
    assign( :all, (records + spotlights).shuffle )

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
    should have_css '.GALLERY .gallery_item', count: 1 + (records + spotlights).count
  }
}
