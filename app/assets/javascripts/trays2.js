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
    if ( action === 'remove' ) {
      if ( confirm( 'Remove this item from the tray?' ) ) {
        $.ajax( {
          type: 'DELETE',
          url: '/tray_items/' + $( this ).closest( '.commandnail' ).data( 'trayItemId' ) + '/destroy',
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
        tray_id: $( this ).data( 'trayId' )
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
  } );
} );
