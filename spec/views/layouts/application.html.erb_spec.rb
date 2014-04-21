require 'spec_helper'

describe ( 'layouts/application' ) {
  subject { rendered }

  context ( 'default layout' ) {
    before {
      render 
    }

    it {
      should have_title 'Curarium'
    }
  }
}
