$( function() {
  var betaPopupHtml = $( '.beta-popup' );

  if ( betaPopupHtml.length ) {
    betaPopupHtml.show().on( 'click', '.close', function() {
      $.magnificPopup.instance.close();
    } );

    $.magnificPopup.open( {
      items: {
        src: betaPopupHtml,
        type: 'inline'
      },
      showCloseBtn: false
    } );

  }
} );
