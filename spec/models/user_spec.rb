require 'spec_helper'

describe ( User ) {
  context ( 'with valid data' ) {
    let ( :u ) { User.first }

    subject { u }

    it { should be_valid }

    it {
      should respond_to :name, :email
    }

    it {
      should respond_to :super
    }

    describe ( 'slug' ) {
      it {
        should respond_to :slug
      }

      it {
        u.slug.should eq( 'test-example-com' )
      }
    }

    describe ( 'circles' ) {
      it {
        u.circles.should_not be_nil
      }
    }

    describe ( 'trays' ) {
      it {
        should respond_to :trays
      }

      it {
        u.circles.first.should respond_to :trays
      }

      it {
        should respond_to :all_trays
      }

      it {
        u.all_trays.include?( u.trays.first ).should be_true
      }

      it {
        u.all_trays.include?( u.circles.first.trays.first ).should be_true
      }
    }
  }
}

