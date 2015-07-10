$( function( ) { 
  $( '.color-viz a.thumbnail' ).click( function( ) {
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
} );
