require 'spec_helper'

describe ( 'works/thumbnail' ) {
  subject { rendered }

  context ( 'normal work' ) {
    let ( :work ) { Work.first }

    before {
      assign( :work, work )
      render 'works/thumbnail', thumbnail: work
    }

    it {
      should have_css 'a.thumbnail'
    }

    it {
      should have_css "a[href*='#{work_path work}']" 
    }

    it {
      should have_css "a[title='#{work.title}']"
    }

    it {
      should_not have_css 'a img'
    }
  }
}
