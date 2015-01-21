require 'spec_helper'

describe ( 'Spotlight model' ) {
  context ( 'with valid data' ) {
    let ( :s ) { Spotlight.first }

    it { s.should be_valid }

    it { s.should respond_to :title, :body }

    it { s.should respond_to :user }

    it { s.should respond_to :waku_url }
  }
}
