$( function() {
  var betaPopupClosed = window.localStorage.getItem( 'betaPopupClosed' );

  if ( betaPopupClosed !== 'y' ) {
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
        showCloseBtn: false,

        callbacks: {
          close: function( ) {
            window.localStorage.setItem( 'betaPopupClosed', 'y' );
          }
        }
      } );
    }
  }
} );
