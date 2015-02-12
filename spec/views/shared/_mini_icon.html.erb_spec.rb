require 'spec_helper'

describe ( 'shared/mini_icon' ) {
  subject { rendered }

  context ( 'defaults' ) {
    before {
      render partial: 'shared/mini_icon', object: 'tray'
    }

    it {
      should have_css '.mini-icon'
    }

    it {
      should have_css '.mini-icon .mini-icon-title', text: 'Tray'
    }

    it {
      should have_css '.mini-icon .mini-icon-icon'
    }

    it {
      should have_css '.mini-icon .mini-icon-tray'
    }

    it ( 'should default icon side to :left' ) {
      should have_css '.mini-icon span:first.mini-icon-icon'
    }
  }

  context ( 'with icon on :right' ) {
    before {
      render partial: 'shared/mini_icon', object: 'tray', locals: { side: :right }
    }

    it ( 'should move icon to left' ) {
      should have_css '.mini-icon span:first.mini-icon-title'
    }
  }

  context ( 'with alternate title' ) {
    before {
      render partial: 'shared/mini_icon', object: 'tray', locals: { icon_title: 'Remove' }
    }

    it {
      should have_css '.mini-icon .mini-icon-tray'
    }

    it {
      should have_css '.mini-icon .mini-icon-title', text: 'Remove'
    }
  }

  context ( 'with no title' ) {
    before {
      render partial: 'shared/mini_icon', object: 'tray', locals: { icon_title: nil }
    }

    it {
      should have_css '.mini-icon.mini-icon-no-title'
    }

    it {
      should have_css '.mini-icon .mini-icon-tray'
    }

    it {
      should_not have_css '.mini-icon .mini-icon-title'
    }
  }
}

