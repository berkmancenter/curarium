require 'spec_helper'

describe 'records requests', :js => true do
  let ( :rec ) { Collection.first.records.first }

  subject { page }

  context ( 'anonymous' ) {
    describe ( 'get /records/:id' ) {
      before {
        visit record_path( rec )
      }

      it {
        should have_title 'Curarium'
      }
    }
  }

  context ( 'with signed in user' ) {
    before {
      visit login_path

      fill_in 'Email:', with: 'test@example.com'
      fill_in 'Password:', with: 't3stus3r'

      click_button 'Login'
    }

    describe ( 'get records#index' ) {
      describe( 'header' ) {
        before {
          visit records_path
        }

        it {
          should have_title 'Records'
        }
      }

      describe ( 'vis_controls' ) {
        context( 'with default vis' ) {
          before {
            visit records_path
          }

          it {
            should have_css '.vis-controls select[name="vis"]'
            should have_css 'option[value="list"][selected]'
          }
        }

        context( 'with list vis' ) {
          before {
            visit "#{records_path}?vis=list"
          }

          it {
            should have_css '.vis-controls select[name="vis"]'
            should have_css 'option[value="list"][selected]'
          }
        }

        context( 'with thumbnails vis' ) {
          before {
            visit "#{records_path}?vis=thumbnails"
          }

          it {
            should have_css '.vis-controls select[name="vis"]'
            should_not have_css 'option[value="list"][selected]'
            should have_css 'option[value="thumbnails"][selected]'
          }
        }
      }
    }

    describe ( 'get /records/:id' ) {
      before {
        visit record_path( rec )
      }

      it {
        should have_title 'Curarium'
      }
    }

    describe ( 'get /records/:id/thumb' ) {
      before {
        visit thumb_record_path( rec )
      }

      it {
        page.status_code.should eq( 200 )
      }
    }
  }
end
