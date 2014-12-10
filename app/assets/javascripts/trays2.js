$( function() {
  // no longer needed after waku integration
  if ( $( '.spotlight_viewedit' ).length ) {
    window.spotlights.components = [];
    window.trays.show();
    window.spotlights.create();
  }

  var trayPopupHtml = $( '.tray-popup' );

  $( '.trays.show .tray-item' )
  .on( 'click', '.move-item, .copy-item', function( ) {
    $.ajax( {
      url: window.location.href + '/..',
      data: {
        popup_action: $( this ).hasClass( 'move-item' ) ? 'move' : 'copy',
        popup_action_item_id: $( this ).closest( '.commandnail' ).data( 'trayItemId' )
      },
      success: function( popupHtml ) {
        $.magnificPopup.open( {
          items: {
            src: popupHtml,
            type: 'inline'
          }
        } );
      }
    } );
  } );

  $( '.trays.show' )
  .on( 'click', '.tray-popup-button', function( ) {
    var popup = $( this ).closest( '.tray-popup' );
    alert( popup.data( 'action' ) + ' tray_item ' + popup.data( 'actionItemId' ) + ' to tray ' + $( this ).data( 'trayId' ) );
  } );
} );
