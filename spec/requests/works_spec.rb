require 'spec_helper'

describe 'works requests', :js => true do
  let ( :col ) { Collection.first }
  let ( :works ) { col.works.all }
  let ( :work ) { works.first }
  let ( :last_supper ) { Work.find_by_title 'Last Supper' }
  let ( :star_attr ) { FactoryGirl.attributes_for :star }

  subject { page }

  context ( 'anonymous' ) {
    describe ( 'get /works/:id' ) {
      context ( 'simple' ) {
        before {
          visit work_path( work )
        }

        it {
          should have_title 'Curarium'
        }

        it {
          should have_css 'body.works.show'
        }
      }

      context ( 'with annotation' ) {
        before {
          visit work_path( last_supper )
        }

        it {
          sleep 1
          should have_title 'Curarium'
        }
      }
    }
  }

  context ( 'with signed in user' ) {
    let ( :user ) { FactoryGirl.attributes_for :test_user }

    before {
      visit login_path
    }

    describe ( 'sign in' ) {
      before {
        fill_in 'email:', with: user[ :email ]
        fill_in 'password:', with: user[ :password ]

        click_button 'login'
      }

      describe ( 'get works#index' ) {
        describe( 'header' ) {
          before {
            visit works_path
          }

          it {
            should have_title 'Records'
          }

          it {
            should have_css 'body.works.index'
          }
        }

        describe ( 'vis=objectmap' ) {
          before {
            visit "#{collection_works_path col}?vis=objectmap"
          }

          it {
            should have_css '.works-objectmap'
          }

          it {
            should have_css '.works-objectmap .geomap'
          }

          it {
            should have_css '.geomap.geo-map'
          }

          it {
            should have_css '.works-objectmap .minimap'
          }

          it {
            should have_css '.minimap.geo-map'
          }
        }

        describe ( 'vis=thumbnails' ) {
          context ( 'without filter' ) {
            before {
              visit "#{collection_works_path col}?vis=thumbnails"
            }

            it {
              should have_css '.works-thumbnails'
            }

            it {
              should have_css '.works-thumbnails a', count: works.count
            }
          }

          context ( 'with one include' ) {
            before {
              visit "#{collection_works_path col}?vis=thumbnails&include[]=title:Starry Night"
            }

            it {
              should have_css '.works-thumbnails a', count: 1
            }
          }
        }

        describe ( 'vis=list' ) {
          context ( 'without filter' ) {
            before {
              visit "#{collection_works_path col}?vis=list"
            }

            it {
              should have_css '.works-list'
            }

            it {
              should have_css '.works-list a', count: works.count
            }

            it {
              should have_css '.works-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.works-list a span', text: 'Mona Lisa'
            }

            it {
              should have_css '.works-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.works-list a span', text: 'Lucrezia'
            }
          }

          context ( 'with one title include' ) {
            before {
              visit "#{collection_works_path col}?vis=list&include[]=title:Starry Night"
            }

            it {
              should have_css '.works-list a', count: 1
            }

            it {
              should have_css '.works-list a span', text: 'Starry Night'
            }

            it {
              should_not have_css '.works-list a span', text: 'Mona Lisa'
            }
          }

          context ( 'with two title includes' ) {
            before {
              visit "#{collection_works_path col}?vis=list&include[]=title:Starry Night&include[]=title:Mona Lisa"
            }

            it {
              # no work has two titles (multiple includes require all)
              should_not have_css '.works-list a'
            }
          }

          context ( 'with one title exclude' ) {
            before {
              visit "#{collection_works_path col}?vis=list&exclude[]=title:Starry Night"
            }

            it {
              should have_css '.works-list a', count: works.count - 1
            }

            it {
              should_not have_css '.works-list a span', text: 'Starry Night'
            }
          }

          context ( 'with two title excludes' ) {
            before {
              visit "#{collection_works_path col}?vis=list&exclude[]=title:Starry Night&exclude[]=title:Mona Lisa"
            }

            it {
              should have_css '.works-list a', count: works.count - 2
            }

            it {
              should_not have_css '.works-list a span', text: 'Starry Night'
            }
            it {
              should_not have_css '.works-list a span', text: 'Mona Lisa'
            }
          }

          describe ( 'with one topics include' ) {
            before {
              visit "#{collection_works_path col}?vis=list&include[]=topics:women"
            }

            it {
              should_not have_css '.works-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.works-list a span', text: 'Mona Lisa'
            }

            it {
              should have_css '.works-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.works-list a span', text: 'Lucrezia'
            }
          }
          
          describe ( 'with two topics includes' ) {
            before {
              visit "#{collection_works_path col}?vis=list&include[]=topics:women&include[]=topics:portraits"
            }

            it {
              should_not have_css '.works-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.works-list a span', text: 'Mona Lisa'
            }

            it {
              should_not have_css '.works-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.works-list a span', text: 'Lucrezia'
            }
          }

          describe ( 'with one topics exclude' ) {
            before {
              visit "#{collection_works_path col}?vis=list&exclude[]=topics:Jesus"
            }

            it {
              should have_css '.works-list a span', text: 'Starry Night'
            }

            it {
              should have_css '.works-list a span', text: 'Mona Lisa'
            }

            it {
              should_not have_css '.works-list a span', text: 'Last Supper'
            }

            it {
              should have_css '.works-list a span', text: 'Lucrezia'
            }
          }

          describe ( 'with two topics excludes' ) {
            before {
              visit "#{collection_works_path col}?vis=list&exclude[]=topics:women&exclude[]=topics:Jesus"
            }

            it {
              should have_css '.works-list a span', text: 'Starry Night'
            }

            it {
              should_not have_css '.works-list a span', text: 'Mona Lisa'
            }

            it {
              should_not have_css '.works-list a span', text: 'Last Supper'
            }

            it {
              should_not have_css '.works-list a span', text: 'Lucrezia'
            }
          }
        }

        describe ( 'vis=treemap' ) {
          context ( 'with title' ) {
            before {
              visit "#{collection_works_path col}?vis=treemap&property=title"
            }

            it {
              should have_css '.node', text: 'Lucrezia(1)'
            }

            describe ( 'click node (10190)' ) {
              before {
                click_link 'lucrezia(1)'
              }

              it ( 'should move to single work page' ) {
                should have_css 'body.works.show'
              }

            }
          }

          context ( 'with topics' ) {
            before {
              visit "#{collection_works_path col}?vis=treemap&property=topics"
            }

            it ( 'should have topics encoded' ) {
              should have_css %[.works-treemap[data-property-counts*="women"]]
              should have_css %[.works-treemap[data-property-counts*="portraits"]]
            }

            it ( 'should not have other values' ) {
              should_not have_css %[.works-treemap[data-property-counts*="gogh"]]
            }
                    
            it {
              # 14 distinct topics in test data, extra .node for root
              should have_css '.node', count: 14 + 1
            }

            it {
              should have_css '.node', text: 'Women(4)'
            }

            it ( 'should not screw up values with commas' ) {
              should_not have_css '.node', text: 'Joseph(1)'
              should have_css '.node', text: 'Joseph, Saint(1)'
            }

            describe ( 'click node' ) {
              before {
                click_link 'portraits(3)'
              }

              it {
                # two women in portraits
                should have_css '.node', text: 'Women(3)'
              }

              describe ( 'click same node' ) {
                before {
                  click_link 'portraits(3)'
                }

                it ( 'should not add portraits to URL a second time' ) {
                  current_url.scan(/(?=portraits)/).count.should eq( 1 )
                }

              }
            }
          }

          describe ( 'treemap topics include one' ) {
            before {
              visit "#{collection_works_path col}?vis=treemap&property=topics&include[]=topics:women"
            }

            it {
              should have_css '.node', count: 11 + 1
            }

            it {
              should have_css '.node', text: 'Women(4)'
            }

            describe ( 'click to one work' ) {
              # clicking a block that narrows to one work should forward to works/show
              before {
                click_link 'death(1)'
              }

              it {
                should have_css 'body.works.show'
              }
            }
          }

          describe ( 'treemap topics include two' ) {
            before {
              visit "#{collection_works_path col}?vis=treemap&property=topics&include[]=topics:women&include[]=topics:portraits"
            }

            it {
              # all topics from only works having both included topics: women & portraits
              should have_css '.node', count: 6 + 1
            }

            it {
              should have_css '.node', text: 'Women(3)'
            }
          }
        }
      }

      describe ( 'get /works/:id' ) {
        before {
          visit work_path( work )
        }

        it {
          should have_title 'Curarium'
        }

        describe ( 'post /works/annotations' ) {
          before {
            sleep 1
            execute_script %Q|$( '.expand_anno' ).show();|

            fill_in 'Title', with: star_attr[ :title ]
            fill_in 'Body', with: star_attr[ :body ]

            execute_script %Q|$( '#content_x' ).val( #{star_attr[ :x ] } );|
            execute_script %Q|$( '#content_y' ).val( #{star_attr[ :y ] } );|
            execute_script %Q|$( '#content_width' ).val( #{star_attr[ :width ] } );|
            execute_script %Q|$( '#content_height' ).val( #{star_attr[ :height ] } );|
            execute_script %Q|$( '#content_image_url' ).val( '#{star_attr[ :image_url ] }' );|
          }

          it ( 'should open annotation popout' ) {
            should have_css '.expand_anno'
          }

          describe ( 'click create' ) {
            before {
              click_button 'Create Annotation'
            }

            it {
              a = Annotation.last
              a.title.should eq( star_attr[ :title ] )
            }
          }
        }
      }

      describe ( 'get /works/:id/thumb' ) {
        before {
          visit thumb_work_path( work )
        }

        it {
          page.status_code.should eq( 200 )
        }
      }
    }
  }
end
