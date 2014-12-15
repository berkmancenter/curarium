require 'spec_helper'

describe ( 'users/show' ) {
  subject { rendered }

  let ( :user ) { User.first }

  before {
    assign( :user, user )
    session[ :user_id ] = user.id
    render
  }

  it {
    should have_css 'h1.collection-header', text: user.name
  }
}
