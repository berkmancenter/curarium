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
    $.get( window.location.href + '/..', function( popupHtml ) {
      $.magnificPopup.open( {
        items: {
          src: popupHtml,
          type: 'inline'
        }
      } );
    } );
  } );
} );
