require 'spec_helper'

describe ( 'tray_items/commandnail' ) {
  subject { rendered }

  context ( 'image tray item' ) {
    let ( :ti ) { TrayItem.first }

    before {
      assign( :tray, ti.tray )
      render 'tray_items/commandnail', commandnail: ti
    }

    it {
      should have_css '.gallery_item'
    }

    it {
      should have_css '.gallery_item.commandnail'
    }

    it {
      should have_css '.gallery_item a', count: 3
    }
  }
}

