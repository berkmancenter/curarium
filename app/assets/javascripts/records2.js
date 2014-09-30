$( function() {
  $( '.records.index' ).on( 'click', '.show-xhr .record-commands .show', function() {
    window.open( $( this ).attr( 'href' ) );
    return false;
  } );

  $( '.records.index' ).on( 'click', '.show-xhr .record-commands .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );
} );
