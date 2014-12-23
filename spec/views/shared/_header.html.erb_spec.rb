require 'spec_helper'

describe ( 'shared/header' ) {
  subject { rendered }

  context ( 'with anonymous' ) {
    before {
      render 'shared/header'
    }

    it {
      should have_css '.GLOBAL_MENU'
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
      assign( :user, user )
      session[ :user_id ] = user.id
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
      should have_css %Q|.toggle_user .dropdown_menu a[href*="#{logout_path}"]|, text: 'Log Out'
    }
  }
}
