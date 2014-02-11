require 'spec_helper'

describe 'collections requests', :js => true do
  subject { page }

  describe ( 'get /collections index' ) {
    context ( 'anonymous' ) {
      before {
        visit collections_path
      }

      it {
        should have_title 'Curarium'
      }

      it {
        should have_css '.curarium_collection', count: 1
      }
    }

    context ( 'with signed in user' ) {
      before {
        visit login_path

        #sign_in User.first
        #visit collections_path
      }

      it {
        snap
        should have_css '.curarium_collection', count: 2
      }
    }
  }
  describe ( 'get /collections/:id' ) {
    let( :col ) { Collection.first }

    before {
      visit collection_path( col )
    }

    it {
      should have_title 'Curarium'
    }

    it {
      should have_css '.record_thumbnail', count: col.records.count
    }
  }
end
