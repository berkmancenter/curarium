$( function( ) { 
  $( '.colorfilter a.thumbnail' ).click( function( ) {
    $.get( $( this ).prop( 'href' ) , function( popupHtml ) {
      $.magnificPopup.open( {
        showCloseBtn: false,
        items: {
          src: popupHtml,
          type: 'inline'
        }
      } );
    } );

    return false;
  } );

  $( '.colorfilter a.color-info' ).click( function( ) {
    var visForm = $( '#vis-form' );
    visForm.find( '#colorfilter' ).attr( 'disabled', false ).val( $( this ).data( 'color' ) );
    visForm.submit( );
    return false;
  } );
} );
