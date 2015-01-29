require 'spec_helper'

describe ( 'users/edit' ) {
  subject { rendered }

  before { 
    assign( :user, User.first )
    render
  }
}

