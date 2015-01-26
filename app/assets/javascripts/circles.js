$( function( ) {
  $( '.join-circle,.leave-circle' ).click( function( ) {
    $( this ).closest( 'form' ).submit();
    return false;
  } );

  $( '.delete-circle' ).click( function( ) {
    if ( confirm( 'Are you sure you want to delete this circle and all of the circle trays?' ) ) {
      $( this ).closest( 'form' ).submit();
    }
    return false;
  } );
} );
