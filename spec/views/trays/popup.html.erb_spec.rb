require 'spec_helper'

describe ( 'trays/popup' ) {
  subject { rendered }

  context ( 'user with tray' ) {
    let ( :user ) { User.first }
    let ( :trays ) { user.all_trays }

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
        # two trays and a create tray button
        should have_css 'button', count: 4
      }

      it {
        should have_css 'button.tray-popup-button', count: 3
      }

      it {
        should have_css 'button[data-tray-id="1"]'
      }

      describe ( 'new tray form' ) {
        it {
          should have_css 'form[action*="trays"][method="post"]'
        }

        it {
          should have_css 'input[type="hidden"][name="tray[owner_id]"]'
        }

        it {
          should have_css 'input[type="hidden"][name="tray[owner_type]"]'
        }

        it {
          should have_css 'input[name="tray[name]"]'
        }
      }

      context ( 'with image_id' ) {
      }
    }

    context ( 'with add action & item params' ) {
      let( :item ) { trays.first.tray_items.first }

      before {
        assign( :owner, user )
        assign( :trays, trays )
        assign( :popup_action, 'add' )
        assign( :popup_action_item_id, Image.first.id ) # image_id since no tray_item yet
        render
      }

      it {
        should have_css '.tray-popup[data-action="add"]'
      }

      it {
        should have_css '.tray-popup button', text: 'test_tray'
        should have_css '.tray-popup button', text: 'empty_tray'
      }

      it {
        should have_css 'button.item-in', text: 'test_tray'
      }

      it {
        should have_css 'button.item-out', text: 'empty_tray'
      }
    }

    context ( 'with put action & item params' ) {
      let( :item ) { trays.first.tray_items.first }

      before {
        assign( :owner, user )
        assign( :trays, trays )
        assign( :popup_action, 'put' )
        assign( :popup_action_item_id, item.id )
        render
      }

      it {
        should have_css '.tray-popup[data-action="put"]'
      }

      it {
        should have_css %Q|.tray-popup[data-action-item-id="#{item.id}"]|
      }

      describe ( 'new tray form' ) {
        it {
          should have_css 'form[action*="trays"]'
        }

        it {
          should have_css 'input[type="hidden"][name="popup_action"][value="put"]'
        }

        it {
          should have_css %Q|input[type="hidden"][name="popup_action_item_id"][value="#{item.id}"]|
        }
      }
    }
  }
}
