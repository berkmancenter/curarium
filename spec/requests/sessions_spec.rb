require 'spec_helper'

describe 'sessions requests', :js => true do
  subject { page }

  before {
    visit login_path
  }

  describe ( 'sign in' ) {
    let ( :user ) { FactoryGirl.attributes_for :test_user }

    before {
      fill_in 'email:', with: user[ :email ]
      fill_in 'password:', with: user[ :password ]

      click_button 'login'
    }

    it {
      should have_title 'Curarium'
    }

    it {
      should have_css '.toggle_user span', text: user[ :name ].upcase
    }
  }
end
