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
      context ( 'test_col' ) {
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
          should have_css '.titlebar', text: col.name
        }

        it {
          # semantically, should be a p element instead of div
          should have_css '.cont_about', text: col.description
        }

        it {
          # works no longer shown on this view
          # only possible as thumbnail visualization
          should_not have_css '.work_thumbnail', count: col.works.count
        }
      }

      context ( 'no works' ) {
        let( :col ) { Collection.find_by_name 'Homeless Paintings of the Italian Renaissance' }

        before {
          visit collection_path( col )
        }

        it {
          should have_title 'Curarium'
        }
      }
    }
  }

  context ( 'with signed in user' ) {
    describe ( 'get /collections index' ) {
      before {
        post login_path
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
