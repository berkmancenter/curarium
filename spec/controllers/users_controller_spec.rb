require 'spec_helper'

describe ( UsersController ) {
  describe ( 'new user' ) {
    it {
      get :new
      response.code.should eq( '400' )
    }
  }
}
