require 'spec_helper'

describe ( 'circles/show' ) {
  subject { rendered }

  let ( :user ) { User.first }
  let ( :user_two ) { User.find_by_name 'User Two' }

  let ( :c ) { Circle.first }
  let ( :c_two ) { Circle.last }

  describe ( 'left bar' ) {
    context ( 'with everyone' ) {
      before {
        assign( :circle, c )
        render
      }

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
    }

    context ( 'with non-admin user' ) {
      context ( 'with circle not joined' ) {
        before {
          session[ :browserid_email ] = user.email
          assign( :current_user, user )

          assign( :circle, c_two )
          render
        }

        it {
          should have_css '.stalking_menu form a.join-circle', text: 'Join Circle'
        }
      }

      context ( 'with circle already joined' ) {
        before {
          session[ :browserid_email ] = user_two.email
          assign( :current_user, user_two )

          assign( :circle, c )
          render
        }

        it {
          should have_css '.stalking_menu form a.leave-circle', text: 'Leave Circle'
        }
      }
    }

    context ( 'with admin user' ) {
      before {
        session[ :browserid_email ] = user.email
        assign( :current_user, user )

        assign( :circle, c )
        render
      }

      it {
        should_not have_css '.stalking_menu a', text: 'Join Circle'
      }

      it {
        should have_css '.stalking_menu a.edit-circle', text: 'Edit Description'
      }

      it {
        should have_css '.stalking_menu form a.delete-circle', text: 'Delete Circle'
      }
    }
  }

  describe ( 'main content' ) {
    context ( 'with everyone' ) {
      before {
        assign( :circle, c )
        render
      }

      it {
        should have_css '.expandable h1'
      }

      it {
        should have_css 'h1.collection-header', text: c.title
      }

      it {
        should have_css 'dt', text: 'Created by:'
        should have_css 'dd', text: user.name
      }

      it {
        should have_css 'dt', text: 'Created on:'
      }

      it {
        should have_css 'dt', text: 'Members:'
        should have_css 'dd', text: 2
      }

      it {
        should have_css 'p', text: c.description
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

      it {
        should_not have_css 'section.circle-collections'
      }
    }

    context ( 'with non-admin user' ) {
      context ( 'with circle not joined' ) {
        before {
          session[ :browserid_email ] = user.email
          assign( :current_user, user )

          assign( :circle, c_two )
          render
        }

        it {
          should_not have_css 'section.circle-collections'
        }
      }

      context ( 'with circle already joined' ) {
        before {
          session[ :browserid_email ] = user_two.email
          assign( :current_user, user_two )

          assign( :circle, c )
          render
        }

        it {
          should have_css 'section.circle-collections'
        }

        it {
          should have_css '.circle-collections .GALLERY'
        }

        it {
          should have_css '.circle-collections .GALLERY .gallery_item.thumbnail.collection-thumbnail'
        }
      }
    }

    context ( 'with admin user' ) {
      before {
        session[ :browserid_email ] = user.email
        assign( :current_user, user )

        assign( :circle, c )
        render
      }

      it {
        should have_css 'section.circle-collections'
      }
    }
  }

  describe ( 'right content' ) {
    context ( 'with everyone' ) {
      before {
        assign( :circle, c )
        render
      }

      it {
        should have_css '.right'
      }

      it {
        should have_css '.right .holder.members'
      }

      it {
        should have_css '.members .titlebar', text: 'Members'
      }

      it {
        should have_css '.members ul'
      }

      it {
        should have_css '.members li a'
      }

      it {
        should have_css '.members a .mini-icon'
      }

      it {
        should have_css '.members a span.mini-icon-title', text: user.name
      }
    }
  }
}
