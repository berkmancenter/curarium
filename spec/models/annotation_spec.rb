require 'spec_helper'

describe ( Annotation ) {
  context ( 'with valid data' ) {
    let ( :a ) { Annotation.first }

    it { a.should be_valid }

    it {
      a.should respond_to( :image, :work )
    }

    it {
      a.should respond_to( :title, :tags, :body )
    }

    it {
      a.should respond_to( :x, :y, :width, :height )
    }

    it {
      a.should respond_to( :thumbnail_url )
    }

    it {
      a.title.should eq( 'jesus' )
    }
  }
}

