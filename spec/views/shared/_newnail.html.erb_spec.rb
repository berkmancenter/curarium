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

  context ( 'with collection' ) {
    before {
      render partial: 'shared/newnail', object: Collection
    }

    it {
      should have_css '.gallery_item'
    }

    it {
      should have_css '.gallery_item .createnew'
    }

    it {
      should have_css %Q|.createnew a[href*="#{new_collection_path}"]|
    }

    it {
      should have_css 'a', text: 'new collection'
    }
  }

  context ( 'with add' ) {
    before {
      render partial: 'shared/newnail', object: Collection, locals: { verb: :add }
    }

    it {
      should have_css 'a', text: 'add collection'
    }
  }
}

