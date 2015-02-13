require 'spec_helper'
require 'browserid-rails'

describe ( 'shared/header' ) {
  subject { rendered }

  context ( 'with anonymous' ) {
    before {
      assign( :header_collections, Collection.where( approved: true ) )
      render 'shared/header'
    }

    it {
      should have_css '.GLOBAL_MENU'
    }

    describe ( 'explore' ) {
      it {
        should have_css %Q|.toggle_explore a[href*="#{collections_path}"]|
      }

      it {
        should have_css '.toggle_explore .dropdown_menu'
      }

      it {
        should have_css '.toggle_explore a', text: 'test_col', visible: false
      }

      it {
        should have_css %Q|.toggle_explore a[href*="#{collection_works_path Collection.first}"]|, visible: false
      }
    }

    it {
      should have_css '.toggle_user'
    }

    it {
      should have_css '.toggle_user span', text: 'Log In'
    }
  }

  context ( 'with signed in user' ) {
    let ( :user ) { User.first }

    before {
      assign( :header_collections, Collection.where( approved: true ) )
      assign( :user, user )
      session[ :browserid_email ] = user.email
      assign( :current_user, user )
      render 'shared/header'
    }

    it {
      should have_css %Q|.toggle_user a[href*="#{user_path user}"]|
    }

    it {
      should have_css '.toggle_user span', text: user.name
    }

    it {
      should have_css '.toggle_user .dropdown_menu'
    }

    it {
      should have_css %Q|.toggle_user .dropdown_menu a[href*="#{edit_user_path user}"]|, text: 'Edit Profile'
    }

    it {
      should have_css %Q|.toggle_user .dropdown_menu a[href*="#{logout_path}"]|, text: 'Logout'
    }
  }
}
