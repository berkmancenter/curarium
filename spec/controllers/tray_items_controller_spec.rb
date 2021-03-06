require 'spec_helper'

describe ( TrayItemsController ) {
  let ( :test_tray ) { Tray.find_by_name( 'test_tray' ) }
  let ( :tray_item ) { TrayItem.first }
  let ( :tray_dst ) { Tray.find_by_name( 'empty_tray' ) }

  before {
    controller.login_browserid User.first.email 
  }

  describe ( 'GET index' ) {
    it {
      get :index
      response.code.should eq( '403' )
    }
  }

  describe ( 'PUT tray_items/:id' ) {
    it ( 'should move the item' ) {
      put :move, id: tray_item.id, tray_item: { tray_id: tray_dst.id }
      response.code.should eq( '200' )

      tray_item.reload
      tray_item.tray.id.should eq( tray_dst.id )
    }
  }

  describe ( 'POST tray_items' ) {
    context ( 'with item not in tray' ) {
      let ( :work ) { Work.find_by_title 'Aphrodite Pudica' }

      it ( 'should return ok' ) {
        post :create, tray_item: { tray_id: tray_dst.id, image_id: work.images.first.id }
        response.code.should eq( '200' )
      }

      it ( 'should create a new item' ) {
        expect {
          post :create, tray_item: { tray_id: tray_dst.id, image_id: work.images.first.id }
        }.to change( TrayItem, :count ).by( 1 )
      }
    }

    context ( 'with item in tray' ) {
      let ( :work ) { Work.first }

      it ( 'should return ok' ) {
        post :create, tray_item: { tray_id: test_tray.id, image_id: work.images.first.id }
        response.code.should eq( '200' )
      }

      it ( 'should remove item' ) {
        expect {
          post :create, tray_item: { tray_id: test_tray.id, image_id: work.images.first.id }
        }.to change( TrayItem, :count ).by( -1 )
      }
    }
  }

  describe ( 'POST tray_items/:id/copy' ) {
    let ( :tray_src ) { tray_item.tray }

    it ( 'should not modify the original item' ) {
      post :copy, id: tray_item.id, tray_item: { tray_id: tray_dst.id }
      response.code.should eq( '200' )

      tray_item.reload
      tray_item.tray.id.should eq( tray_src.id )
    }

    it ( 'should copy the item' ) {
      expect {
        post :copy, id: tray_item.id, tray_item: { tray_id: tray_dst.id }
      }.to change( TrayItem, :count ).by( 1 )
    }
  }

  describe ( 'DELETE tray_items/:id' ) {
    it ( 'should return ok' ) {
      delete :destroy, id: tray_item.id
      response.code.should eq( '200' )
    }

    it ( 'should delete the item' ) {
      expect {
        delete :destroy, id: tray_item.id
      }.to change( TrayItem, :count ).by( -1 )
    }
  }

}
