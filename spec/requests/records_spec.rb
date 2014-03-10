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

    describe ( 'get /records/:id' ) {
      before {
        visit record_path( rec )
      }

      it {
        should have_title 'Curarium'
      }
    }
  }
end