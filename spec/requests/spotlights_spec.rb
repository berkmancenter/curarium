require 'spec_helper'

describe 'spotlights requests' do

  context ( 'waku' ) {
    context ( 'user spotlight' ) {
      let ( :u ) { User.first }

      describe ( 'post /users/:id/spotlights' ) {
        before {
          post "#{user_spotlights_path( user_id: u.id )}.json", spotlight: {
            title: 'user spotlight',
            privacy: 'private',
            body: 'body',
            waku_id: 523,
            waku_url: 'waku.com/523'
          }
        }

        it {
          puts page.source
          page.status_code.should eq( 200 )
        }
      }
    }
  }
end
