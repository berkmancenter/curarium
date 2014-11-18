require 'spec_helper'

describe 'users requests', :js => true do
  subject { page }

  context ( 'anonymous' ) {
    describe ( 'get users/new' ) {
      before {
        visit new_user_path
        page.execute_script( "$( '.beta-popup .close' ).click();" )
      }

      describe ( 'beta popup' ) {
        it {
          should_not have_css '.beta-popup'
        }

        describe ( 'click beta' ) {
          before {
            click_link 'beta'
          }

          it {
            should have_css '.beta-popup'
          }
        }
      }
    }
  }

end

