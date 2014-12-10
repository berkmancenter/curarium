require 'spec_helper'

describe ( 'trays/popup' ) {
  subject { rendered }

  context ( 'user with tray' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.trays }

    context ( 'with default popup' ) {
      before {
        assign( :owner, user )
        assign( :trays, trays )
        render
      }

      it {
        should have_css 'h1', text: 'Your Trays'
      }

      it {
        should have_css 'button', count: 2
      }

      it {
        should have_css 'button.tray-popup-button', count: 2
      }

      it {
        should have_css 'button[data-tray-id="1"]'
      }
    }

    context ( 'with move action & item params' ) {
      let( :item ) { trays.first.tray_items.first }

      before {
        assign( :owner, user )
        assign( :trays, trays )
        assign( :popup_action, 'move' )
        assign( :popup_action_item, item )
        render
      }

      it {
        should have_css '.tray-popup[data-action="move"]'
      }

      it {
        should have_css %Q|.tray-popup[data-action-item-id="#{item.id}"]|
      }

    }
  }
}
