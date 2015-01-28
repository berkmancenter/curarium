require 'spec_helper'

describe ( 'shared/newnail' ) {
  subject { rendered }

  context ( 'with circle' ) {
    before {
      render partial: 'shared/newnail', object: Circle
    }

    it {
      should have_css '.gallery_item'
    }

    it {
      should have_css '.gallery_item .createnew'
    }

    it {
      should have_css %Q|.createnew a[href*="#{new_circle_path}"]|
    }

    it {
      should have_css 'a', text: 'new circle'
    }
  }
}

