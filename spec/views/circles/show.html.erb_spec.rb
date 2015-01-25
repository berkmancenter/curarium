require 'spec_helper'

describe ( 'circles/show' ) {
  subject { rendered }

  let ( :user ) { User.first }
  let ( :user_two ) { User.find_by_name 'User Two' }

  let ( :c ) { Circle.first }

  before {
    assign( :circle, c )
    render
  }

  describe ( 'left bar' ) {
    it {
      should have_css '.left'
    }

    it {
      should have_css '.left .holder.col-sidebar'
    }

    it {
      should have_css '.col-sidebar .titlebar.main', text: 'Circle'
    }

    it {
      should have_css '.col-sidebar .thumbnail'
    }

    it {
      should have_css '.col-sidebar .stalking_menu_holder'
    }

    it {
      should have_css '.stalking_menu_holder .stalking_menu'
    }

    it {
      should_not have_css '.stalking_menu a', text: 'Join Circle'
    }

    context ( 'with admin user' ) {
      before {
        session[ :browserid_email ] = user.email
        assign( :current_user, user )
        render
      }

      it {
        should_not have_css '.stalking_menu a', text: 'Join Circle'
      }

      it {
        should have_css '.stalking_menu a.delete-circle', text: 'Delete Circle'
      }
    }

    context ( 'with non-admin user' ) {
      before {
        session[ :browserid_email ] = user_two.email
        assign( :current_user, user_two )
        render
      }

      it {
        should have_css '.stalking_menu a.join-circle', text: 'Join Circle'
      }
    }
  }

  describe ( 'main content' ) {
    it {
      should have_css '.expandable h1'
    }

    it {
      should have_css 'h1.collection-header', text: c.title
    }

    it {
      should have_css 'section.circle-trays'
    }

    it {
      should have_css 'h1.collection-header', text: 'Trays'
    }

    it {
      should have_css '.tray-preview'
    }

    it {
      should have_css %Q|a[href*="#{circle_trays_path c}"]|, text: 'Tray Manager'
    }
  }
}
