require 'spec_helper'

describe ( Circle ) {
  context ( 'with valid data' ) {
    let ( :c ) { Circle.first }

    subject { c }

    it { should be_valid }

    it {
      should respond_to :title, :description
    }

    it {
      should respond_to :admin, :users
    }

    describe ( 'trays' ) {
      it {
        should respond_to :trays
      }

      it {
        c.trays.first.images.first.work.title.should eq( 'Aphrodite Pudica' )
      }
    }

    describe ( 'thumbnail' ) {
      it {
        should respond_to :thumbnail_url
      }

      it {
        c.thumbnail_url.should eq( c.trays.first.images.first.thumbnail_url )
      }
    }
  }
}
