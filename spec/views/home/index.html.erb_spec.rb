require 'spec_helper'

describe ( 'home/index' ) {
  subject { rendered }

  let( :works ) { Work.limit(10).order("RANDOM()") }
  let( :collection ) { Collection.limit(1).order("RANDOM()").first }
  let( :spotlights ) { Spotlight.limit(10).order("RANDOM()") }

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
}
