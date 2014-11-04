require 'spec_helper'

describe ( 'Image model' ) {
  context ( 'with valid data' ) {
    let ( :i ) { Image.first }

    it { i.should be_valid }

    it { i.should respond_to 'image_url' }
    it { i.should respond_to 'thumbnail_url' }

    it { i.should respond_to 'record' }

    it {
      i.record.should_not eq( nil )
    }
  }
}
