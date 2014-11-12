require 'spec_helper'

describe ( 'users/new' ) {
  subject { rendered }

  before { 
    assign( :user, User.new )
    render
  }

  it {
    should have_css 'h1', text: 'Sign up!'
  }

  it {
    should have_css 'p a', text: 'beta'
  }

  it {
    should have_css 'p a', text: 'click here'
  }
}
