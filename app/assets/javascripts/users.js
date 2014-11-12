$( function( ) { 
  $( '.send-secret' ).click( function( ) {
    $( 'input[name="send_secret"]' ).val( 'y' );
    $( '.signup form' ).submit( );
  } );
} );
