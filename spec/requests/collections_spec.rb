require 'spec_helper'

describe 'collections requests', :js => true do
  subject { page }

  context ( 'anonymous' ) {
    describe ( 'get /collections index' ) {
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
  }

  context ( 'with signed in user' ) {
    before {
      visit login_path

      fill_in 'Email:', with: 'test@example.com'
      fill_in 'Password:', with: 't3stus3r'

      click_button 'Login'
    }

    describe ( 'get /collections index' ) {
      before {
        visit collections_path
      }

      it {
        should have_css '.curarium_collection', count: 2
      }
    }
  }
end
