$( function() {
  $( '.collections.show .delete-collection' ).click( function() {
    if ( !confirm( 'Are you sure you want to delete this collection and all works and annotations within?' ) ) {
      return false;
    }
  } );

  if ( $( '.collections.new' ).length ) {
    /*
    $( window ).on( 'beforeunload', function( e ) {
      return 'Data you have entered will not be saved.';
    } );
    */

    //introJs().start();
  }
} );
