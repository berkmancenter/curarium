require 'spec_helper'

describe ( 'Tray model' ) {
  context ( 'with valid data' ) {
    let ( :t ) { Tray.first }

    it { t.should be_valid }

    it { t.should respond_to 'name' }

    it { t.should respond_to 'owner' }

    it { t.should respond_to 'tray_items' }

    it { t.should respond_to 'images' } # through tray_items
    it { t.should respond_to 'annotations' } # through tray_items

    it ( 'should no longer have visualizations attribute' ) {
      t.should_not respond_to 'visualizations'
    }

    it ( 'should no longer have specific works attribute' ) {
      t.should_not respond_to 'works'
    }

    it {
      t.owner.class.should eq( User )
    }
  }

  describe ( 'tray_items' ) {
    let ( :t ) { Tray.first }

    context ( 'Image' ) {
      it {
        t.images.first.should eq( Image.first )
      }
    }

    context ( 'Annotation' ) {
      it {
        t.annotations.first.should eq( Annotation.first )
      }
    }
  }
}
