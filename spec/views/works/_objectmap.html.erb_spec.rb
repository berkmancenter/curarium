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
      should have_css %[.works-objectmap[data-work-ids="[#{works.map { |w| w.id }.join(',')}]"]]
    }

    it {
      should have_css '.works-objectmap[data-work-thumbs]'
    }

    it {
      should have_css %[.works-objectmap[data-work-thumbs="[#{works.map { |w| w.thumb_hash }.join(',')}]"]]
    }

    it {
      should have_css '.works-objectmap div.geomap'
    }

    it {
      should have_css '.works-objectmap div.minimap'
    }
  }
}
