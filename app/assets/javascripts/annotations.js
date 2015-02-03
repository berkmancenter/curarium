$( function( ) {
  $( '.delete-annotation' ).click( function( ) {
    if ( confirm( 'Are you sure you want to delete this annotation?' ) ) {
      $( this ).closest( 'form' ).submit();
    }
    return false;
  } );
} );
