require 'spec_helper'

describe 'home requests', :js => true do
  subject { page }

  context ( 'anonymous' ) {
    describe ( 'get home/index' ) {
      before {
        visit root_path
        page.execute_script( "window.localStorage.removeItem('betaPopupClosed');" )
      }

      describe ( 'beta popup' ) {
        it {
          should have_css '.beta-popup'
        }

        describe ( 'click continue' ) {
          before {
            click_button 'continue'
          }

          it {
            should_not have_css '.beta-popup'
          }

          describe ( 'refresh after close' ) {
            before {
              visit root_path
            }

            it ( 'should remember popup was closed' ) {
              should_not have_css '.beta-popup'
            }
          }
        }
      }
    }
  }

end
