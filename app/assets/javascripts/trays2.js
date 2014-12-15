$( function() {
  // no longer needed after waku integration
  if ( $( '.spotlight_viewedit' ).length ) {
    window.spotlights.components = [];
    window.trays.show();
    window.spotlights.create();
  }

  var trayPopupHtml = $( '.tray-popup' );

  $( '.trays.show .tray-item' )
  .on( 'click', '[data-action]', function( ) {
    var action = $( this ).data( 'action' );
    if ( action === 'destroy' ) {
      if ( confirm( 'Remove this item from the tray?' ) ) {
        $.ajax( {
          type: 'DELETE',
          url: '/tray_items/' + $( this ).closest( '.commandnail' ).data( 'trayItemId' ),
        } )
        .done( function( result ) {
          window.location.reload();
        } );
      }
    } else {
      $.ajax( {
        url: window.location.href + '/..',
        data: {
          popup_action: action,
          popup_action_item_id: $( this ).closest( '.commandnail' ).data( 'trayItemId' )
        }
      } )
      .done( function( popupHtml ) {
        $.magnificPopup.open( {
          items: {
            src: popupHtml,
            type: 'inline'
          }
        } );
      } );
    }
  } );

  $( '.works.show' )
  .on( 'click', '.tray-popup-button', function( ) {
    var popup = $( this ).closest( '.tray-popup' );
    $.ajax( {
      type: 'POST',
      url: '/tray_items',
      data: {
        'tray_item[tray_id]': $( this ).data( 'trayId' ),
        'tray_item[image_id]': popup.data( 'actionItemId' )
      }
    } )
    .done( function( result ) {
      window.location.reload();
    } )
    .fail( function( result ) {
      alert( result );
    } );
  } );

  $( '.trays.show' )
  .on( 'click', '.tray-popup-button', function( ) {
    var actionTypes = {
      move: 'PUT',
      copy: 'POST'
    };

    var popup = $( this ).closest( '.tray-popup' );
    $.ajax( {
      type: actionTypes[ popup.data( 'action' ) ],
      url: '/tray_items/' + popup.data( 'actionItemId' ) + '/' + popup.data( 'action' ),
      data: {
        'tray_item[tray_id]': $( this ).data( 'trayId' )
      }
    } )
    .done( function( result ) {
      $.magnificPopup.instance.close();
      window.location.reload();
    } )
    .fail( function( result ) {
      $.magnificPopup.instance.close();
      alert( result );
    } );
  } )
  .on( 'submit', '.new_tray', function( e ) {
    var $form = $( this );
    //alert( $( this ).serialize() );
    $.ajax( {
      type: 'POST',
      url: $form.attr( 'action' ),
      data: $form.serialize()
    } )
    .done( function( popupHtml ) {
      $.magnificPopup.instance.close();
      $.magnificPopup.open( {
        items: {
          src: popupHtml,
          type: 'inline'
        }
      } );
      //$form.closest( '.mfp-content' ).html( result );
    } );
    return false;
  } );
} );
