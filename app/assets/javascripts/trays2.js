$( function() {
  // no longer needed after waku integration
  if ( $( '.spotlight_viewedit' ).length ) {
    window.spotlights.components = [];
    window.trays.show();
    window.spotlights.create();
  }

  var trayPopupHtml = $( '.tray-popup' );

  $( '.move-item, .copy-item' ).click( function( ) {
    $.magnificPopup.open( {
      items: {
        src: trayPopupHtml.show(),
        type: 'inline'
      }
    } );

  } );


} );
