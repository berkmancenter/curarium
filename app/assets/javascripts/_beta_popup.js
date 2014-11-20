$( function() {
  var betaPopupHtml = $( '.beta-popup' );

  if ( betaPopupHtml.length ) {
    var betaPopupClosed = window.localStorage.getItem( 'betaPopupClosed' );

    if ( betaPopupClosed !== 'y' ) {
      popup();
    }

    $( 'a.beta' ).click( function() {
      popup();
    } );
  }

  function popup() {
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
} );
