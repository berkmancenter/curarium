require 'spec_helper'

describe ( 'users/form' ) {
  let ( :u ) { User.first }

  subject { rendered }

  # new users are no longer allowed to be created via this form

  context ( 'with edit user' ) {
    before { 
      assign( :user, u )
      render partial: 'users/form'
    }

    it {
      should have_css 'form'
    }

    it {
      should have_css '.login_signup'
    }

    it {
      should have_css 'input[name="user[name]"]'
    }

    it {
      should_not have_css 'input[name="user[email]"]'
    }

    it {
      should have_css %Q|textarea[name="user[bio]"]|, text: u.bio
    }

    it {
      should_not have_css 'button', text: 'sign up'
    }

    it {
      should have_css 'button', text: 'save'
    }
  }
}
