require 'spec_helper'

describe 'records requests', :js => true do
  let ( :col ) { Collection.first }
  let ( :recs ) { col.records.all }
  let ( :rec ) { recs.first }

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
    }

    describe ( 'sign in' ) {
      before {
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

        describe ( 'vis=objectmap' ) {
          before {
            visit "#{collection_records_path col}?vis=objectmap"
          }

          it {
            should have_css '.records-objectmap'
          }

          it {
            should have_css '.records-objectmap .geomap'
          }

          it {
            should have_css '.geomap.geo-map'
          }

          it {
            should have_css '.records-objectmap .minimap'
          }

          it {
            should have_css '.minimap.geo-map'
          }
        }

        describe ( 'vis=thumbnails' ) {
          context ( 'without filter' ) {
            before {
              visit "#{collection_records_path col}?vis=thumbnails"
            }

            it {
              should have_css '.records-thumbnails'
            }

            it {
              should have_css '.records-thumbnails a', count: recs.count
            }
          }

          context ( 'with one include' ) {
            before {
              visit "#{collection_records_path col}?vis=thumbnails&include[]=title:Starry Night"
            }

            it {
              should have_css '.records-thumbnails a', count: 1
            }
          }
        }

        describe ( 'vis=list' ) {
          context ( 'without filter' ) {
            before {
              visit "#{collection_records_path col}?vis=list"
            }

            it {
              should have_css '.records-list'
            }

            it {
              should have_css '.records-list a', count: recs.count
            }

            it {
              should have_css '.records-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.records-list a span', text: 'Mona Lisa'
            }

            it {
              should have_css '.records-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.records-list a span', text: 'Lucrezia'
            }
          }

          context ( 'with one title include' ) {
            before {
              visit "#{collection_records_path col}?vis=list&include[]=title:Starry Night"
            }

            it {
              should have_css '.records-list a', count: 1
            }

            it {
              should have_css '.records-list a span', text: 'Starry Night'
            }

            it {
              should_not have_css '.records-list a span', text: 'Mona Lisa'
            }
          }

          context ( 'with two title includes' ) {
            before {
              visit "#{collection_records_path col}?vis=list&include[]=title:Starry Night&include[]=title:Mona Lisa"
            }

            it {
              # no record has two titles (multiple includes require all)
              should_not have_css '.records-list a'
            }
          }

          context ( 'with one title exclude' ) {
            before {
              visit "#{collection_records_path col}?vis=list&exclude[]=title:Starry Night"
            }

            it {
              should have_css '.records-list a', count: recs.count - 1
            }

            it {
              should_not have_css '.records-list a span', text: 'Starry Night'
            }
          }

          context ( 'with two title excludes' ) {
            before {
              visit "#{collection_records_path col}?vis=list&exclude[]=title:Starry Night&exclude[]=title:Mona Lisa"
            }

            it {
              should have_css '.records-list a', count: recs.count - 2
            }

            it {
              should_not have_css '.records-list a span', text: 'Starry Night'
            }
            it {
              should_not have_css '.records-list a span', text: 'Mona Lisa'
            }
          }

          describe ( 'with one topics include' ) {
            before {
              visit "#{collection_records_path col}?vis=list&include[]=topics:women"
            }

            it {
              should_not have_css '.records-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.records-list a span', text: 'Mona Lisa'
            }

            it {
              should have_css '.records-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.records-list a span', text: 'Lucrezia'
            }
          }
          
          describe ( 'with two topics includes' ) {
            before {
              visit "#{collection_records_path col}?vis=list&include[]=topics:women&include[]=topics:portraits"
            }

            it {
              should_not have_css '.records-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.records-list a span', text: 'Mona Lisa'
            }

            it {
              should_not have_css '.records-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.records-list a span', text: 'Lucrezia'
            }
          }

          describe ( 'with one topics exclude' ) {
            before {
              visit "#{collection_records_path col}?vis=list&exclude[]=topics:Jesus"
            }

            it {
              should have_css '.records-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.records-list a span', text: 'Mona Lisa'
            }

            it {
              should_not have_css '.records-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.records-list a span', text: 'Lucrezia'
            }
          }

          describe ( 'with two topics excludes' ) {
            before {
              visit "#{collection_records_path col}?vis=list&exclude[]=topics:women&exclude[]=topics:Jesus"
            }

            it {
              should have_css '.records-list a span', text: 'Starry Night'
            }

            it {
              should_not have_css '.records-list a span', text: 'Mona Lisa'
            }

            it {
              should_not have_css '.records-list a span', text: 'Last Supper'
            }

            it {
              should_not have_css '.records-list a span', text: 'Lucrezia'
            }
          }
        }

        describe ( 'vis=treemap' ) {
          context ( 'with topics' ) {
            before {
              visit "#{collection_records_path col}?vis=treemap&property=topics"
            }

            it ( 'should have topics encoded' ) {
              should have_css %[.records-treemap[data-property-counts*="women"]]
              should have_css %[.records-treemap[data-property-counts*="portraits"]]
            }

            it ( 'should not have other values' ) {
              should_not have_css %[.records-treemap[data-property-counts*="gogh"]]
            }
                    
            it {
              # 13 distinct topics in test data, extra .node for root
              should have_css '.node', count: 13 + 1
            }

            it {
              should have_css '.node', text: 'Women(3)'
            }

            it ( 'should not screw up values with commas' ) {
              should_not have_css '.node', text: 'Joseph(1)'
              should have_css '.node', text: 'Joseph, Saint(1)'
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
  }
end
