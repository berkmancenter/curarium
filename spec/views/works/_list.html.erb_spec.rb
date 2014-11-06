require 'spec_helper'

describe ( 'works/list' ) {
  subject { rendered }

  context ( 'all works' ) {
    let ( :works ) { Work.all }

    before {
      render partial: 'works/list', object: works
    }

    it {
      should have_css 'ul.works-list'
    }

    it {
      should have_css 'li', count: works.count
    }
  }
}
