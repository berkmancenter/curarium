require 'spec_helper'

describe ( 'annotations/show' ) {
  subject { rendered }

  let ( :user ) { User.first }
  let ( :a ) { Annotation.first }

  context ( 'normal layout' ) {
    before {
      assign( :annotation, a )
      assign( :work, a.work )
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
        should have_css '.col-sidebar .titlebar.main', text: 'Annotation'
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
        should have_css '.stalking_menu a.show-annotation-work', text: 'View Record'
      }

      it {
        should_not have_css '.stalking_menu a.edit-annotation'
      }

      it {
        should_not have_css '.stalking_menu form a.delete-annotation'
      }

      context ( 'with owner' ) {
        before {
          session[ :browserid_email ] = user.email
          assign( :current_user, user )
          render
        }

        it {
          should have_css '.stalking_menu a.edit-annotation', text: 'Edit Annotation'
        }

        it {
          should have_css '.stalking_menu form a.delete-annotation', text: 'Delete Annotation'
        }
      }
    }

    describe ( 'main content' ) {
      it {
        should have_css '.expandable h1'
      }

      it {
        should have_css 'h1.collection-header', text: a.title
      }

      it {
        should have_css 'p', text: a.body
      }

      context ( 'with owner' ) {
        before {
          session[ :browserid_email ] = user.email
          assign( :current_user, user )
          render
        }

        it {
          should have_css '.annotation-commands'
        }
      }
    }
  }

  context ( 'with xhr' ) {
    before {
      assign( :annotation, a )
      assign( :work, a.work )

      assign( :popup_action, 'add' )
      assign( :popup_action_type, 'Annotation' )
      assign( :popup_action_item_id, a.id )

      assign( :xhr, true )
      render template: 'annotations/show', layout: false

    }

    it {
      should have_css '.annotation-xhr'
    }

    it {
      should have_css %Q|.annotation-xhr[data-action-item-type="Annotation"]|
    }

    it {
      should have_css %Q|.annotation-xhr[data-action-item-id="#{a.id}"]|
    }

    it {
      should have_css '.popup-commands'
    }

    it {
      should have_css '.popup-commands a.close'
    }

    it {
      should_not have_css 'a.show-annotation-work'
    }
  }
}
