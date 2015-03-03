require 'spec_helper'

describe ( 'Spotlight model' ) {
  context ( 'with valid data' ) {
    let ( :s ) { Spotlight.first }

    it { s.should be_valid }

    it { s.should respond_to :title, :body }

    it { s.should respond_to :user, :privacy }

    it { s.should respond_to :waku_id, :waku_url }
  }

  context ( 'circle spotlights' ) {
    let ( :ss ) { Spotlight.circle_only }

    it {
      ss.count.should eq( 1 )
    }

    it {
      ss.first.title.should eq( 'spotlight_two_circle' )
    }
  }
}
