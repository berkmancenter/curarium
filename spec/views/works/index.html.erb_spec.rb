require 'spec_helper'

describe ( 'works/index' ) {
  subject { rendered }

  before {
    assign( :properties, [ 'title', 'artist', 'topics' ] )
  }

  context ( 'all works' ) {
    before {
      assign( :works, Work.all )
      render
    }

    it {
      should_not have_css 'h1', text: 'Records'
    }

    it {
      should have_css 'section.vis-controls'
    }
  }

  context ( 'in a collection' ) {
    let ( :collection ) { Collection.first }

    before {
      assign( :collection, collection )
      assign( :works, collection.works )
      render
    }

    it {
      # just show the works
      should_not have_css 'h1', text: "Records for #{collection.name}"
    }
  }

  describe ( 'vis_controls' ) {
    context( 'with default vis' ) {
      before {
        assign( :works, Work.all )
        render
      }

      it {
        should have_css 'section.vis-controls'
      }

      it {
        should have_css '.vis-controls select[name="vis"]'
      }

      it {
        should have_css 'option[value="list"]'
        should have_css 'option[value="thumbnails"]'
        should have_css 'option[value="objectmap"]'
      }

      it {
        should have_css 'option[value="objectmap"][selected]'
      }

      it {
        should have_css '.works-objectmap'
      }
    }

    context( 'with list vis' ) {
      before {
        assign( :works, Work.all )
        render template: 'works/index.html.erb', locals: { params: { 'vis' => 'list' } }
      }

      it {
        should have_css 'option[value="list"][selected]'
        should_not have_css 'option[value="thumbnails"][selected]'
        should_not have_css 'option[value="objectmap"][selected]'
      }

      it {
        should have_css '.works-list'
      }
    }

    context( 'with thumbnails vis' ) {
      before {
        assign( :works, Work.all )
        render template: 'works/index.html.erb', locals: { params: { 'vis' => 'thumbnails' } }
      }

      it {
        should_not have_css 'option[value="list"][selected]'
        should have_css 'option[value="thumbnails"][selected]'
        should_not have_css 'option[value="objectmap"][selected]'
      }

      it {
        should have_css '.works-thumbnails'
      }
    }

    context( 'with objectmap vis' ) {
      before {
        assign( :works, Work.all )
        render template: 'works/index.html.erb', locals: { params: { 'vis' => 'objectmap' } }
      }

      it {
        should_not have_css 'option[value="list"][selected]'
        should_not have_css 'option[value="thumbnails"][selected]'
        should have_css 'option[value="objectmap"][selected]'
      }

      it {
        should have_css '.works-objectmap'
      }
    }
  }
}
