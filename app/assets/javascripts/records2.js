$( function() {
  $( '.records.index' ).on( 'click', '.show-xhr .record-commands .close', function() {
    $.magnificPopup.instance.close();
    return false;
  } );
} );
