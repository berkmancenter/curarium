require 'spec_helper'

describe ( 'works/objectmap' ) {
  subject { rendered }

  context ( 'all works' ) {
    let ( :works ) { Work.all }

    before {
      render partial: 'works/objectmap', object: works
    }

    it {
      should have_css 'section.works-objectmap'
    }

    it {
      should have_css '.works-objectmap[data-work-ids]'
    }

    it {
      should have_css %[.works-objectmap[data-work-ids="[#{works.map { |r| r.id }.join(',')}]"]]
    }

    it {
      should have_css '.works-objectmap div.geomap'
    }

    it {
      should have_css '.works-objectmap div.minimap'
    }
  }
}
