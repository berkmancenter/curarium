require 'spec_helper'

describe 'collections requests', :js => true do
  subject { page }

  describe ( 'get /collections index' ) {
    before {
      visit( collections_path )
    }

    it {
      should have_title 'Curarium'
    }
  }

  describe ( 'get /collections/:id' ) {
    let( :col ) { Collection.first }

    before {
      visit( collection_path( col ) )
    }

    it {
      snap
      should have_title 'Curarium'
    }

    it {
      should have_css '.record_thumbnail', count: col.records.count
    }
  }
end
