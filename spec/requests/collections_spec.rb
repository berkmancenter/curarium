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
        # should non-signed in users see the New Collection button?
        should have_css '.gallery_item', count: 5
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
        should have_css 'body.collections.show'
      }

      it {
        should have_css '.page_title', text: col.name
      }

      it {
        # semantically, should be a p element instead of div
        should have_css '.cont_about', text: col.description
      }

      it {
        # records no longer shown on this view
        # only possible as thumbnail visualization
        should_not have_css '.record_thumbnail', count: col.records.count
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
        should have_css 'body.collections.index'
      }

      it {
        should have_css '.gallery_item', count: 5
      }
    }
  }
end
