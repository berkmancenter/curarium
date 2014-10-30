require 'spec_helper'

describe ( 'records/list_item' ) {
  subject { rendered }

  context ( 'normal record' ) {
    let ( :work ) { Record.first }

    before {
      render partial: 'records/list_item', object: record
    }

    it {
      should have_css 'li'
    }

    it {
      should have_css 'li a'
    }

    it {
      should have_css "a[href*='#{record_path record}']" 
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
      should have_css 'span', text: record.title
    }
  }
}
