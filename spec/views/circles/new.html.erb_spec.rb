require 'spec_helper'

describe ( 'circles/new' ) {
  subject { rendered }

  let ( :user ) { User.first }
  let ( :c ) { Circle.new }

  before {
    # can only get here if signed in
    session[ :browserid_email ] = user.email
    assign( :current_user, user )

    assign( :circle, c )
    render
  }

  it {
    should have_css 'h1', 'New Circle'
  }
}
