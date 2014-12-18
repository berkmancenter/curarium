require 'spec_helper'

describe ( 'tray_items/commandnail' ) {
  subject { rendered }

  context ( 'base tray item' ) {
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
      should have_css '.tray-item.commandnail'
    }

    it {
      should have_css %Q|.commandnail[data-tray-item-id="#{ti.id}"]|
    }

    it {
      should have_css '.commandnail a', count: 4
    }

    it {
      should have_css '.commandnail a.view-item'
    }

    it {
      should have_css '.commandnail a[data-action="copy"]'
    }

    it {
      should have_css '.commandnail a[data-action="move"]'
    }

    it {
      should have_css '.commandnail a[data-action="destroy"]'
    }
  }

  context ( 'image tray item' ) {
    let ( :ti ) { TrayItem.find 1 }

    before {
      assign( :tray, ti.tray )
      render 'tray_items/commandnail', commandnail: ti
    }

    it {
      should have_css %Q|.commandnail a.view-item[href*="#{work_path( ti.image.work )}"]|
    }
  }

  context ( 'annotation tray item' ) {
    let ( :ti ) { TrayItem.find 2 }

    before {
      assign( :tray, ti.tray )
      render 'tray_items/commandnail', commandnail: ti
    }

    it {
      should have_css %Q|.commandnail a.view-item[href*="#{work_path( ti.annotation.work )}"]|
    }
  }
}

