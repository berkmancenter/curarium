require 'spec_helper'

describe 'records requests', :js => true do
  let ( :rec ) { Collection.first.records.first }

  subject { page }

  context ( 'anonymous' ) {
    describe ( 'get /records/:id' ) {
      before {
        visit record_path( rec )
      }

      it {
        should have_title 'Curarium'
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

    describe ( 'get records#index' ) {
      before {
        visit records_path
      }

      it {
        should have_title 'Records'
      }
    }

    describe ( 'get /records/:id' ) {
      before {
        visit record_path( rec )
      }

      it {
        should have_title 'Curarium'
      }
    }

    describe ( 'get /records/:id/thumb' ) {
      before {
        visit thumb_record_path( rec )
      }

      it {
        page.status_code.should eq( 200 )
      }
    }
  }
end
