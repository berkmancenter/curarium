require 'spec_helper'

describe ( 'works/show' ) {
  subject { rendered }

  let ( :work ) { Work.find_by_title 'Aphrodite Pudica' }

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
        should have_css '.expand_tray', visible: false
      }

      it {
        should have_css %Q|.expand_tray .tray-popup[data-action="add"][data-action-item-type="Image"][data-action-item-id="#{work.images.first.id}"]|, visible: false
      }
    }
  }
}
