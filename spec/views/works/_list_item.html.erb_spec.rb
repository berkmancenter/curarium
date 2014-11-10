require 'spec_helper'

describe ( 'works/list_item' ) {
  subject { rendered }

  context ( 'normal work' ) {
    let ( :work ) { Work.first }

    before {
      render partial: 'works/list_item', object: work
    }

    it {
      should have_css 'li'
    }

    it {
      should have_css 'li a'
    }

    it {
      should have_css "a[href*='#{work_path work}']" 
    }

    it {
      should have_css 'a img'
    }

    it {
      should have_css 'a span'
    }

    it {
      should have_css 'img~span'
    }

    it {
      should have_css 'span', text: work.title
    }
  }
}
