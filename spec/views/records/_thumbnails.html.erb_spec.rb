require 'spec_helper'

describe ( 'works/thumbnails' ) {
  subject { rendered }

  context ( 'all works' ) {
    let ( :works ) { Work.all }

    before {
      render partial: 'records/thumbnails', object: records
    }

    it {
      should have_css 'section.works-thumbnails'
    }

    it {
      should have_css 'a', count: records.count
    }

    it {
      should have_css 'img', count: records.count
    }
  }
}
