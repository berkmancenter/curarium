require 'spec_helper'

describe ( 'works/show' ) {
  subject { rendered }

  let ( :work ) { Work.find_by_title 'Last Supper' }

  context ( 'with anonymous' ) {
    before {
      assign( :work, work )
      assign( :current_metadata, work.parsed )
      
      render
    }

    describe ( 'parsed info' ) {
      it {
        should have_css '.parsed-info', visible: false
      }
    }
  }

  context ( 'with signed in user' ) {
    let ( :owner ) { User.first }

    before {
      session[ :user_id ] = owner.id

      assign( :work, work )
      assign( :current_metadata, work.parsed )

      assign( :owner, owner )
      assign( :trays, owner.trays )
      assign( :popup_action, 'add' )
      assign( :popup_action_type, 'Image' )
      assign( :popup_action_item_id, work.images.first.id )
      
      render
    }

    describe ( 'add to tray' ) {
      it {
        should have_css '.expand_tray .tray-popup', visible: false
      }

      it {
        should have_css %Q|.tray-popup[data-action="add"][data-action-item-type="Image"][data-action-item-id="#{work.images.first.id}"]|, visible: false
      }
    }

    describe ( 'annotations' ) {
      describe ( 'form' ) {
        it {
          should have_css '.expand_anno #annotations', visible: false
        }

        it {
          should have_css '#annotations form#new_annotation', visible: false
        }

        it {
          should have_css %Q|#new_annotation[action="#{work_annotations_path( work )}"]|, visible: false
        }

        it {
          should have_css '#new_annotation input[type="text"][name="annotation[title]"]', visible: false
        }

        it {
          #10915 removing tags for now
          should_not have_css '#new_annotation input[type="hidden"][name="annotation[tags]"]', visible: false
        }

        it {
          should have_css '#new_annotation input[type="hidden"][name="annotation[image_url]"]', visible: false
        }

        it {
          should have_css '#new_annotation input[type="hidden"][name="annotation[thumbnail_url]"]', visible: false
        }

        it {
          #10915 removing tags for now
          should_not have_css 'select.tag_selector'
        }
      }
    }

    describe ( 'list' ) {
      it {
        
      }
    }
  }
}
