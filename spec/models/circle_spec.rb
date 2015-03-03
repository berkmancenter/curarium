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

    describe ( 'collections' ) {
      it {
        should respond_to :collections
      }

      it {
        c.collections.first.name.should eq( 'test_col' )
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

    describe ( 'scope for_user' ) {
      let ( :u ) { User.first }
      let ( :cs_for_u ) { Circle.for_user u }

      it {
        cs_for_u.include?( c ).should be_true
      }

      it {
        cs_for_u.include?( Circle.find_by_title 'circle_two' ).should be_true
      }

      it {
        cs_for_u.include?( Circle.find_by_title 'circle_four' ).should be_false
      }

      it {
        cs_for_u.include?( Circle.find_by_title 'circle_five' ).should be_true
      }

      it {
        cs_for_u.include?( Circle.find_by_title 'circle_six' ).should be_true
      }
    }
  }
}
