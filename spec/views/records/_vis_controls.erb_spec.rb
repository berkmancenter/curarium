require 'spec_helper'

describe ( 'records/vis_controls' ) {
  subject { rendered }

  context ( 'no arguments' ) {
    before {
      render partial: 'records/vis_controls', request: { original_url: '/records/' }
    }

    it {
      should have_css 'section.vis-controls'
    }

    it {
      should have_css '.vis-controls h2', text: 'Visualization Controls'
    }

    it {
      should have_css 'form'
    }

    it { 
      should have_css 'select[name="vis"]'
    }

    it {
      should have_css 'option[value="list"]'
      should have_css 'option[value="thumbnails"]'
    }
  }
}